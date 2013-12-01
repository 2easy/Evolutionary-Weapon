#!/usr/bin/env ruby

D = 10
N = 5
LR,MR,DR = 0.01,0.01,0.01

class Individual
  attr_accessor :chromosome
  def initialize p
    @chromosome = []
    p.each { |pi| @chromosome.push(binary_random(pi)) }
  end
  def size;        @chromosome.size;     end
  def []= (i,val); @chromosome[i] = val; end
  def [] i;        @chromosome[i];       end
end

def binary_random p;            rand < p ? 1 : 0; end
def initial_probability_vector; [0.5]*D;          end
def random_population p, n
  population = []
  n.times { population.push Individual.new(p) }
  population
end
# fitness funct and term cond defining OneMax benchmark problem
def fit ind;       ind.chromosome.inject(0,:+);       end
def term_cond ppl; ppl.any? { |i| fit(i) == i.size }; end

def print_ppl(ppl)
  ppl.each {|i| print fit(i), " "}
  puts
end

def pbil n,lr,mr,dr
  p = initial_probability_vector
  ppl = random_population(p, n)
  while not term_cond ppl
    x = ppl.max_by {|i| fit(i) }
    p.size.times do |i|
      # learn
      p[i] = p[i]*(1-lr)+x[i]*lr
      # and mutate
      p[i] = p[i]*(1-dr)+binary_random(0.5)*dr if rand < mr
    end
    ppl = random_population(p, n)
  end
  print_ppl(ppl)
end

pbil N, LR,MR,DR
