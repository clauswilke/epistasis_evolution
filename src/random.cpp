#include "random.h"

void Random::set_seed(int seed)
{
	m_runif.engine().seed(seed);
	m_runif.distribution().reset();
}