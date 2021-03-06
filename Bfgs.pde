//import lbfgsb.Minimizer;

class ContinuousDiff implements DifferentiableFunction {
  
    Config cfg = null;  
  
    public ContinuousDiff(Config x) { cfg = x; }
    
    public FunctionValues getValues(double[] point) {
      Config temp = new Config(point, cfg.p); 
      double functionValue = func_eval(temp);
      double[] gradient = func_diff(temp, 0.001);//func_diff_2(temp, 0.001);
      return new FunctionValues(functionValue, gradient);
    }
}

class BfgsListener implements IterationFinishedListener {
    public boolean iterationFinished(double[] point, double functionValue, double[] gradient)  {
      //println(String.format("Listener iteration - fval: %g", functionValue));
      return true; // continue algorithm
    }
}

List<Bound> bounds = null;
Minimizer solver = new Minimizer();

  public void init_bfgs_bounds(int n) {
      bounds = new ArrayList<Bound>();
      Bound bx = new Bound((double)c.xmin, (double)c.xmax);
      Bound by = new Bound((double)c.ymin, (double)c.ymax);
      for(int i=0; i<n; i++) {
        if (i%2==0) {
          bounds.add(bx);
        } else {
          bounds.add(by);
        }
      }
  }

class BfgsSolver {
 
  public double minimize(Config x) {
      try {
        // optimizes only rect centers, p - fixed
        //mini.setNoBounds(n);  // solve unbounded
        solver.setBounds(bounds); // set bounds, should speed it up
        //solver.setIterationFinishedListener(new BfgsListener());
        Result result = solver.run(new ContinuousDiff(x), x.c);
        x.c = result.point;
        return result.functionValue;
      } catch (LBFGSBException ex) {
        println(ex);
      }
      return 0; // error
  }
}

