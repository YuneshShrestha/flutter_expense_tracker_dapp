const ExpenseManager = artifacts.require("ExpenseManager");

module.exports = function(deployer)
{
    deployer.deploy(ExpenseManager);
}