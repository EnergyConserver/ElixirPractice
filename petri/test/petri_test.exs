defmodule PetriTest do
  use ExUnit.Case
  doctest Petri

  test "presetL obtiene correctamente el preset de una transición" do
    f = Petri.ex1l()
    preset = Petri.presetL(f, A)
    assert MapSet.equal?(preset, MapSet.new([P0]))
  end

  test "postsetL obtiene correctamente el postset de una transición" do
    f = Petri.ex1l()
    postset = Petri.postsetL(f, A)
    assert MapSet.equal?(postset, MapSet.new([P1, P2]))
  end

  test "fireL ejecuta una transición correctamente" do
    f = Petri.ex1l()
    m = MapSet.new([P0])
    m2 = Petri.fireL(f, A, m)
    assert MapSet.equal?(m2, MapSet.new([P1, P2]))
  end

  test "presetM obtiene correctamente el preset usando mapa" do
    g = Petri.ex1m()
    preset = Petri.presetM(g, A)
    assert MapSet.equal?(preset, MapSet.new([P0]))
  end

  test "postsetM obtiene correctamente el postset usando mapa" do
    g = Petri.ex1m()
    postset = Petri.postsetM(g, A)
    assert MapSet.equal?(postset, MapSet.new([P1, P2]))
  end

  test "fireM ejecuta una transición correctamente con mapa" do
    g = Petri.ex1m()
    m = MapSet.new([P0])
    m2 = Petri.fireM(g, A, m)
    assert MapSet.equal?(m2, MapSet.new([P1, P2]))
  end

  test "enablement con lista M={p1,p4}" do
    f = Petri.ex1l()
    m = MapSet.new([P1,P4])
    result = Petri.enablementL(f,m)
    assert MapSet.equal?(result, MapSet.new([B]))
  end

  test "enablement con lista M={p1,p2}" do
    f = Petri.ex1l()
    m = MapSet.new([P1,P2])
    result = Petri.enablementL(f,m)
    assert MapSet.equal?(result, MapSet.new([B,C,D]))
  end

  test "enablement con mapa M={p1,p4}" do
    g = Petri.ex1m()
    m = MapSet.new([P1,P4])
    result = Petri.enablementM(g,m)
    assert MapSet.equal?(result, MapSet.new([B]))
  end

  test "enablement con mapa M={p1,p2}" do
    g = Petri.ex1m()
    m = MapSet.new([P1,P2])
    result = Petri.enablementM(g,m)
    assert MapSet.equal?(result, MapSet.new([B,C,D]))
  end
end
