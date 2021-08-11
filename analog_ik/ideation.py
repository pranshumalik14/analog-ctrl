from time import sleep
from spatialmath import SE3
import roboticstoolbox as rtb

# instantiate 3D browser-based visualizer
import swift

robot = rtb.models.DH.Panda()
print(robot)

T = robot.fkine(robot.qz)  # forward kinematics
print(T)


T = SE3(0.7, 0.2, 0.1) * SE3.OA([0, 1, 0], [0, 0, -1])
sol = robot.ikine_LM(T)         # solve IK
print(sol)

q_pickup = sol.q
# FK shows that desired end-effector pose was achieved
print(robot.fkine(q_pickup))

qt = rtb.jtraj(robot.qz, q_pickup, 50)
# robot.plot(qt.q, movie='panda1.gif')

robot = rtb.models.URDF.Panda()  # load URDF version of the Panda
print(robot)    # display the model

backend = swift.Swift()
backend.launch(browser='firefox')
backend.add(robot)        # add robot to the 3D scene

sleep(10.0)

for qk in qt.q:           # for each joint configuration on trajectory
    robot.q = qk          # update the robot state
    backend.step()        # update visualization
