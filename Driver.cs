using System;

using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace Quantum.adder
{
    class Driver
    {
        static void Main(string[] args)
        {
            var rand = new System.Random();
            using (var qsim = new QuantumSimulator())
            {
                for (var i = 0; i < 10; i++)
                {
                    int length = 8;
                    int a = rand.Next((int)Math.Pow(2, length));
                    int b = rand.Next((int)Math.Pow(2, length));
                    System.Console.Write(" {0} + {1} = ", a, b);
                    var result = QuantumAdder.Run(qsim, a, b, length).Result;
                    System.Console.WriteLine("{0}", result);
                }
                System.Console.ReadLine();
            }
        }
    }
}
