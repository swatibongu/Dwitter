
const DwitterMain = artifacts.require("DwitterMain");
const DwitterManage = artifacts.require("DwitterManage");
module.exports = async (deployer) => {

    await deployer.deploy(DwitterMain);
    await deployer.deploy(DwitterManage);
};