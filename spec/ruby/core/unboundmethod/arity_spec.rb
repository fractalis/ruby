require File.expand_path('../../../spec_helper', __FILE__)

describe "UnboundMethod#arity" do
  SpecEvaluate.desc = "for method definition"

  context "returns zero" do
    evaluate <<-ruby do
        def m() end
      ruby

      method(:m).unbind.arity.should == 0
    end

    evaluate <<-ruby do
        def n(&b) end
      ruby

      method(:n).unbind.arity.should == 0
    end
  end

  context "returns positive values" do
    evaluate <<-ruby do
        def m(a) end
        def n(a, b) end
        def o(a, b, c) end
        def p(a, b, c, d) end
      ruby

      method(:m).unbind.arity.should == 1
      method(:n).unbind.arity.should == 2
      method(:o).unbind.arity.should == 3
      method(:p).unbind.arity.should == 4
    end

    evaluate <<-ruby do
        def m(a:) end
        def n(a:, b:) end
        def o(a: 1, b:, c:, d: 2) end
      ruby

      method(:m).unbind.arity.should == 1
      method(:n).unbind.arity.should == 1
      method(:o).unbind.arity.should == 1
    end

    evaluate <<-ruby do
        def m(a, b:) end
        def n(a, b:, &l) end
      ruby

      method(:m).unbind.arity.should == 2
      method(:n).unbind.arity.should == 2
    end

    evaluate <<-ruby do
        def m(a, b, c:, d: 1) end
        def n(a, b, c:, d: 1, **k, &l) end
      ruby

      method(:m).unbind.arity.should == 3
      method(:n).unbind.arity.should == 3
    end
  end

  context "returns negative values" do
    evaluate <<-ruby do
        def m(a=1) end
        def n(a=1, b=2) end
      ruby

      method(:m).unbind.arity.should == -1
      method(:n).unbind.arity.should == -1
    end

    evaluate <<-ruby do
        def m(a, b=1) end
        def n(a, b, c=1, d=2) end
      ruby

      method(:m).unbind.arity.should == -2
      method(:n).unbind.arity.should == -3
    end

    evaluate <<-ruby do
        def m(a=1, *b) end
        def n(a=1, b=2, *c) end
      ruby

      method(:m).unbind.arity.should == -1
      method(:n).unbind.arity.should == -1
    end

    evaluate <<-ruby do
        def m(*) end
        def n(*a) end
      ruby

      method(:m).unbind.arity.should == -1
      method(:n).unbind.arity.should == -1
    end

    evaluate <<-ruby do
        def m(a, *) end
        def n(a, *b) end
        def o(a, b, *c) end
        def p(a, b, c, *d) end
      ruby

      method(:m).unbind.arity.should == -2
      method(:n).unbind.arity.should == -2
      method(:o).unbind.arity.should == -3
      method(:p).unbind.arity.should == -4
    end

    evaluate <<-ruby do
        def m(*a, b) end
        def n(*a, b, c) end
        def o(*a, b, c, d) end
      ruby

      method(:m).unbind.arity.should == -2
      method(:n).unbind.arity.should == -3
      method(:o).unbind.arity.should == -4
    end

    evaluate <<-ruby do
        def m(a, *b, c) end
        def n(a, b, *c, d, e) end
      ruby

      method(:m).unbind.arity.should == -3
      method(:n).unbind.arity.should == -5
    end

    evaluate <<-ruby do
        def m(a, b=1, c=2, *d, e, f) end
        def n(a, b, c=1, *d, e, f, g) end
      ruby

      method(:m).unbind.arity.should == -4
      method(:n).unbind.arity.should == -6
    end

    evaluate <<-ruby do
        def m(a: 1) end
        def n(a: 1, b: 2) end
      ruby

      method(:m).unbind.arity.should == -1
      method(:n).unbind.arity.should == -1
    end

    evaluate <<-ruby do
        def m(a=1, b: 2) end
        def n(*a, b: 1) end
        def o(a=1, b: 2) end
        def p(a=1, *b, c: 2, &l) end
      ruby

      method(:m).unbind.arity.should == -1
      method(:n).unbind.arity.should == -1
      method(:o).unbind.arity.should == -1
      method(:p).unbind.arity.should == -1
    end

    evaluate <<-ruby do
        def m(**k, &l) end
        def n(*a, **k) end
        def o(a: 1, b: 2, **k) end
      ruby

      method(:m).unbind.arity.should == -1
      method(:n).unbind.arity.should == -1
      method(:o).unbind.arity.should == -1
    end

    evaluate <<-ruby do
        def m(a=1, *b, c:, d: 2, **k, &l) end
      ruby

      method(:m).unbind.arity.should == -2
    end

    evaluate <<-ruby do
        def m(a, b=1, *c, d, e:, f: 2, **k, &l) end
        def n(a, b=1, *c, d:, e:, f: 2, **k, &l) end
        def o(a=0, b=1, *c, d, e:, f: 2, **k, &l) end
        def p(a=0, b=1, *c, d:, e:, f: 2, **k, &l) end
      ruby

      method(:m).unbind.arity.should == -4
      method(:n).unbind.arity.should == -3
      method(:o).unbind.arity.should == -3
      method(:p).unbind.arity.should == -2
    end
  end

  context "for a Method generated by respond_to_missing?" do
    it "returns -1" do
      obj = mock("method arity respond_to_missing")
      obj.should_receive(:respond_to_missing?).and_return(true)

      obj.method(:m).unbind.arity.should == -1
    end
  end
end