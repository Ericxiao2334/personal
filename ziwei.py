import turtle as t
# 定义一个曲线绘制函数
def DegreeCurve(n, r, d=1):
    for i in range(n):
        t.left(d)
        t.circle(r, abs(d))
# 初始位置设定
s = 0.2 # size
t.setup(450*5*s, 750*5*s)
t.pencolor("black")
t.fillcolor("LemonChiffon")
t.speed(100)
t.penup()
t.goto(0, 900*s)
t.pendown()
#flower
t.begin_fill()
t.left(180)
t.right(45)
t.circle(50*s,90)
DegreeCurve(60, 50*s)
t.circle(80*s,90)
DegreeCurve(4, 100*s)
t.circle(90*s,30)
DegreeCurve(30, 50*s)
t.circle(200*s,65)
DegreeCurve(50, 70*s)
t.circle(200*s,90)
DegreeCurve(40, 70*s)
t.circle(200*s,105)
t.right(20)
t.circle(80*s,60)
t.right(45)
t.forward(150*s)
t.circle(150*s,90)

t.right(30)
t.circle(120*s,90)
t.right(60)
t.circle(200*s,90)

t.right(45)
t.circle(120*s,120)
t.forward(150*s)
t.circle(-100*s,90)
t.end_fill()

t.penup()
t.left(180)
t.circle(100*s,90)
t.forward(150*s)
t.circle(-120*s,120)
t.right(90)
t.pendown()
t.circle(200*s,30)
t.circle(-200*s,60)
t.forward(200*s)

t.penup()
t.left(180)
t.forward(200*s)
t.circle(200*s,60)
t.circle(-200*s,30)
t.right(45)
t.circle(-200*s,90)
t.pendown()
t.right(60)
t.circle(-300*s,40)
t.circle(150*s,60)
t.right(60)
t.forward(200*s)

t.penup()
t.right(180)
t.forward(200*s)
t.left(60)
t.circle(-150*s,60)
t.circle(300*s,40)
t.left(60)
t.right(120)
t.circle(-120*s,90)
t.pendown()
#t.right(30)
t.circle(-130*s,90)
t.circle(110*s,90)
t.circle(-50*s,90)

#branch
t.penup()
t.left(180)
t.circle(50*s,90)
t.circle(-110*s,90)
t.circle(130*s,90)
t.circle(120*s,90)
t.pendown()

t.right(140)
DegreeCurve(20, 2500*s)
DegreeCurve(100, 250*s, -1)

#leaves
# leaf1
t.fillcolor('green')
t.penup()
t.goto(670*s,-180*s)
t.pendown()
t.right(140)
t.begin_fill()
t.circle(300*s,120)
t.left(60)
t.circle(300*s,120)
t.end_fill()
t.penup()
t.goto(180*s,-550*s)
t.pendown()
t.right(75)
t.circle(600*s,20)
t.circle(-600*s,20)
t.circle(300*s,20)
#leaf
t.penup()
t.goto(-100*s,0*s)
t.pendown()
t.begin_fill()
t.left(60)
t.circle(300*s,120)
t.left(60)
t.circle(300*s,120)
t.end_fill()
t.penup()
t.goto(-20*s,-100*s)
t.pendown()
t.right(240)
t.right(30)
t.circle(600*s,35)

t.done()
