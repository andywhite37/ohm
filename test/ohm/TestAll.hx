package ohm;

import utest.Assert;
import utest.Runner;
import utest.ui.Report;

class TestAll {
  public static function main() {
    var runner = new Runner();
    addTests(runner);
    Report.create(runner);
    runner.run();
  }

  static function addTests(runner : Runner) : Void {
    runner.addCase(new ohm.common.message.TestClientMessage());
  }
}
