#include "random.h"

namespace Random {

void Random::set_seed(int seed)
{
	m_runif.engine().seed(seed);
	m_runif.distribution().reset();
}

Random rng(1);

}