using MathOptInterface
const MOI = MathOptInterface
const MOIB = MOI.Bridges
const MOIT = MOI.Test

const BRIDGED = MOIB.full_bridge_optimizer(SCIP.Optimizer(display_verblevel=0), Float64)
const CONFIG = MOIT.TestConfig(atol=1e-5, rtol=1e-5, duals=false, infeas_certificates=false)

@testset "MOI Continuous Linear" begin
    excluded = [
        "linear1",  # needs MOI.delete (of variables in constraints)
        "linear5",  # needs MOI.delete (of variables in constraints)
        "linear11", # broken in SCIP (#2556)
        "linear13", # TODO: support MOI.FEASIBILITY_SENSE
        "linear14", # needs MOI.delete (of variables in constraints)
        "partial_start", # TODO: supportVariablePrimalStart
    ]
    MOIT.contlineartest(BRIDGED, CONFIG, excluded)
end

@testset "MOI Continuous Conic" begin
    MOIT.lintest(BRIDGED, CONFIG)

    # needs VectorAffineFunction
    # MOIT.soctest(BRIDGED, CONFIG)

    # other cones not supported
end

@testset "MOI Quadratic Constraint" begin
    MOIT.qcptest(BRIDGED, CONFIG)
end

@testset "MOI Integer Linear" begin
    MOIT.intlineartest(BRIDGED, CONFIG)
end

@testset "MOI Integer Conic" begin
    # needs VectorAffineFunction
    # MOIT.intconictest(BRIDGED, CONFIG)
end
