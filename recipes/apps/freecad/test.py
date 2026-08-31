import FreeCAD as App
import Part

doc = App.newDocument("CubeTest")

# Create a 10 x 20 x 30 mm cube
cube = Part.makeBox(10, 20, 30)

obj = doc.addObject("Part::Feature", "Cube")
obj.Shape = cube
doc.recompute()

volume = cube.Volume
print(f"Volume: {volume}")

App.closeDocument("CubeTest")
