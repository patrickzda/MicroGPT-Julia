```@meta
CurrentModule = MicroGPT
```

# Autograd

MicroGPT is build upon a small **reverse-mode automatic differentiation engine**.
Wraps matrices / vectors in [`AValue`](@ref) nodes, which can 
be combined using supported operations to build a computation graph.
Calling [`backward!`](@ref) from a final **scalar** loss result walks
that graph in reverse and populates the gradient of every node.


```@example autograd
using MicroGPT

W = AValue([1.0 2.0; 3.0 4.0])
x = AValue([5.0, 6.0])

y = W * x
loss = sum(relu(y))
backward!(loss)

@show W.grad
@show x.grad
nothing # hide
```

## Supported Operations

Note that not all possible operations are supported, as only the 
ones needed for this project have been implemented.
Supported operations include arithmetic (`+`, `-`, `*`, `/`), the elementwise
helpers [`mul_elementwise`](@ref), [`div_elementwise`](@ref) and
[`pow_elementwise_scalar`](@ref), reductions and reshaping (`sum`, `getindex`,
`vcat`, `hcat`, `transpose`), and neural-network building blocks such as
[`relu`](@ref), [`linear`](@ref), [`softmax`](@ref) and [`rmsnorm`](@ref).

## The tape

By default [`backward!`](@ref) discovers the graph structure lazily: starting
from the loss node it recursively walks the `parents` of each node to build a
topological order, then replays the pullbacks in reverse. This works, but the
recursive walk has to be redone on every backward pass.

To avoid that, the engine can **record a tape**, a flat `Vector` of the nodes
in the order they were created (which is already a valid topological order).
Wrap the forward pass in [`record!`](@ref) to capture it:

```@example autograd
using MicroGPT

W = AValue([1.0 2.0; 3.0 4.0])
x = AValue([5.0, 6.0])

tape = record!() do
    y = W * x
    sum(relu(y))
end

loss = last(tape)   # the tape ends with the final node of the forward pass
backward!(loss, tape)

@show W.grad
@show x.grad
nothing # hide
```

Passing the recorded `tape` to [`backward!`](@ref) skips the recursive graph
walk entirely: the reverse pass simply iterates the tape backwards and calls
each node's pullback. This is what MicroGPT uses in its training loop, where the
same graph shape is backpropagated many times.