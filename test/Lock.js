const { expect } = require("chai");

describe("EtherDome", function () {
  let Project, project, admin, user;

  beforeEach(async () => {
    Project = await ethers.getContractFactory("Project");
    [admin, user] = await ethers.getSigners();
    project = await Project.deploy();
  });

  it("Should allow deposits", async function () {
    await project.connect(user).deposit({ value: ethers.parseEther("1") });
    const deposit = await project.deposits(1);
    expect(deposit.amount).to.equal(ethers.parseEther("1"));
  });

  it("Should allow admin to withdraw", async function () {
    await project.connect(user).deposit({ value: ethers.parseEther("0.5") });
    await project.withdraw(1);
    const deposit = await project.deposits(1);
    expect(deposit.withdrawn).to.equal(true);
  });

  it("Should return correct deposit details", async function () {
    await project.connect(user).deposit({ value: ethers.parseEther("2") });
    const deposit = await project.getDeposit(1);
    expect(deposit.amount).to.equal(ethers.parseEther("2"));
  });
});
