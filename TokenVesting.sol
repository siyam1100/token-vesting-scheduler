// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract TokenVesting is Ownable, ReentrancyGuard {
    struct VestingSchedule {
        address beneficiary;
        uint256 start;
        uint256 cliff;
        uint256 duration;
        uint256 totalAmount;
        uint256 released;
    }

    IERC20 public immutable token;
    mapping(address => VestingSchedule) public schedules;

    event Released(address indexed beneficiary, uint256 amount);

    constructor(address _token) Ownable(msg.sender) {
        token = IERC20(_token);
    }

    function createSchedule(
        address _beneficiary,
        uint256 _start,
        uint256 _cliff,
        uint256 _duration,
        uint256 _amount
    ) external onlyOwner {
        require(schedules[_beneficiary].totalAmount == 0, "Schedule exists");
        schedules[_beneficiary] = VestingSchedule(
            _beneficiary, _start, _cliff, _duration, _amount, 0
        );
    }

    function release() external nonReentrant {
        VestingSchedule storage schedule = schedules[msg.sender];
        require(schedule.totalAmount > 0, "No schedule found");

        uint256 releasable = _getReleasableAmount(schedule);
        require(releasable > 0, "Nothing to release");

        schedule.released += releasable;
        token.transfer(schedule.beneficiary, releasable);

        emit Released(schedule.beneficiary, releasable);
    }

    function _getReleasableAmount(VestingSchedule memory _schedule) internal view returns (uint256) {
        if (block.timestamp < _schedule.start + _schedule.cliff) {
            return 0;
        } else if (block.timestamp >= _schedule.start + _schedule.duration) {
            return _schedule.totalAmount - _schedule.released;
        } else {
            uint256 timeFromStart = block.timestamp - _schedule.start;
            uint256 vestedAmount = (_schedule.totalAmount * timeFromStart) / _schedule.duration;
            return vestedAmount - _schedule.released;
        }
    }
}
