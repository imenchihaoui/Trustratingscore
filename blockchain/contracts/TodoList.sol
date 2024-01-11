pragma solidity ^0.5.0;
//contract TrustRatingSystem 
contract TodoList {
    struct CSPFeedback {
        uint256 positiveResponses;
        uint256 collectedResponses;
        uint256 marginError;
    }

    mapping(address => CSPFeedback) public cspFeedback;
    mapping(address => uint256) public trustRatings;

    // Event to log when a new trust rating is provided
    event TrustRatingUpdated(address indexed csp, uint256 newRating);

    // Function to provide customer feedback and update trust rating
    function provideCustomerFeedback(uint256 collectedResponses, uint256 positiveResponses, uint256 marginError) external {
        // Update CSP feedback data
        CSPFeedback storage feedback = cspFeedback[msg.sender];
        feedback.positiveResponses += positiveResponses;
        feedback.collectedResponses += collectedResponses;
        feedback.marginError = marginError;

        // Update trust rating for the CSP
        updateTrustRating();
    }

    // Function to update trust rating based on customer feedback
    function updateTrustRating() internal {
        CSPFeedback storage feedback = cspFeedback[msg.sender];

        // Calculate new trust rating based on the provided formula
        uint256 newTrustRating = (feedback.positiveResponses + feedback.marginError) * feedback.marginError / (feedback.collectedResponses + feedback.marginError);

        // Update trust rating for the CSP
        trustRatings[msg.sender] = newTrustRating;

        emit TrustRatingUpdated(msg.sender, newTrustRating);
    }


    // Function to get the trust rating for a specific CSP
    function getTrustRating(address csp) external view returns (uint256) {
        return trustRatings[csp];
    }
}
