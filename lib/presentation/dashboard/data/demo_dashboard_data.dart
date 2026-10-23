import '../models/dashboard_models.dart';

abstract final class DemoDashboardData {
  static const experiences = <Experience>[
    Experience(
      id: 'exp-botos',
      title: 'Travessia dos Botos & Vivência Comunitária no Tumbira',
      category: ExperienceCategory.boats,
      providerName: 'Seu Raimundo Nonato',
      price: 120,
      priceUnit: 'por participante',
      rating: 4.9,
      reviews: 42,
      imageUrl: 'https://images.pexels.com/photos/12292784/pexels-photo-12292784.jpeg?auto=compress&cs=tinysrgb&h=650&w=940',
      community: 'Comunidade do Tumbira',
    ),
    Experience(
      id: 'exp-samauma',
      title: 'Trilha da Samaúma Milenar',
      category: ExperienceCategory.trails,
      providerName: 'Marcos Apurinã',
      price: 90,
      priceUnit: 'por pessoa',
      rating: 4.8,
      reviews: 31,
      imageUrl: 'https://images.pexels.com/photos/13809456/pexels-photo-13809456.jpeg?auto=compress&cs=tinysrgb&h=650&w=940',
      community: 'Comunidade Apurinã',
    ),
    Experience(
      id: 'exp-biojoias',
      title: 'Biojoias em Sementes de Jarina',
      category: ExperienceCategory.crafts,
      providerName: 'Dona Zete',
      price: 45,
      priceUnit: 'peça',
      rating: 5,
      reviews: 28,
      imageUrl: 'https://images.pexels.com/photos/10877371/pexels-photo-10877371.jpeg?auto=compress&cs=tinysrgb&h=650&w=940',
      community: 'Ateliê Ribeirinho',
    ),
    Experience(
      id: 'exp-moqueado',
      title: 'Peixe Moqueado Tradicional',
      category: ExperienceCategory.food,
      providerName: 'Dona Antônia',
      price: 45,
      priceUnit: 'refeição',
      rating: 4.9,
      reviews: 55,
      imageUrl: 'https://images.pexels.com/photos/29852479/pexels-photo-29852479.jpeg?auto=compress&cs=tinysrgb&h=650&w=940',
      community: 'Cozinha Tradicional',
    ),
  ];
}
