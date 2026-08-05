import emerge as em

# Sizes of the waveguide box
mm = 0.001  # Define a millimeter
wg_width = 22.86 * mm  # Width of WR90 waveguide
wg_height = 10.16 * mm  # Height of WR90 waveguide
wg_length = 50 * mm  # Arbitrary length

model = em.Simulation("MyFirstModel")

# Generate a box consisting of air with the appropriate dimensions
box = em.geo.Box(wg_width, wg_length, wg_height)
model.commit_geometry()
model.view(screenshot="001-emerge-box.png", off_screen=True)

# Set frequency range of the simulation
model.mw.set_frequency_range(8e9, 10e9, 21)

model.generate_mesh()
model.view(plot_mesh=True, screenshot="002-emerge-mesh.png", off_screen=True)

# Boundary conditions for feed ports
port1 = model.mw.bc.RectangularWaveguide(box.front, 1)
port2 = model.mw.bc.RectangularWaveguide(box.back, 2)

# Run frequency-domain sweep and extract S-parameters
fdata = model.mw.run_sweep()
freqs = fdata.scalar.grid.freq

S11 = fdata.scalar.grid.S(1, 1)
S21 = fdata.scalar.grid.S(2, 1)

from emerge.plot import plot_sp

# Plot the S-parameters in dB and phase
plot_sp(
    freqs,
    [S11, S21],
    labels=["S11", "S21"],
    dblim=[-60, 3],
    show_plot=False,
    filename="003-emerge-plot.png",
)
