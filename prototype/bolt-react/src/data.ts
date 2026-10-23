import type { AppData, Experience, Badge, BoatTrip, Trail, CraftItem, Meal } from './types';

export const seedExperiences: Experience[] = [
  {
    id: 'exp-botos',
    title: 'Travessia dos Botos & Vivência Comunitária no Tumbira',
    category: 'barcos',
    providerName: 'Seu Raimundo Nonato',
    providerRole: 'barqueiro',
    price: 120,
    priceUnit: 'por participante',
    rating: 4.9,
    reviews: 42,
    image: 'https://images.pexels.com/photos/12292784/pexels-photo-12292784.jpeg?auto=compress&cs=tinysrgb&h=650&w=940',
    community: 'Comunidade do Tumbira',
    duration: '4 Horas',
    maxCapacity: 'Até 8 pessoas',
    passportStamps: '+2 Selos Culturais',
    description:
      'Navegação silenciosa pelos igarapés do Rio Negro, parada na casa de farinha ancestral, visita à feira de artesanato das mulheres ribeirinhas e banho de rio seguro.',
    providerAvatar: 'https://images.pexels.com/photos/28124841/pexels-photo-28124841.jpeg?auto=compress&cs=tinysrgb&h=400&w=400',
    providerRoleTitle: 'Condutor Fluvial Homologado • Cadastur Verificado',
    providerBadge: '18 anos de experiência no Rio Negro',
    boat: 'Voadeira Rio Negro II',
  },
  {
    id: 'exp-samauma',
    title: 'Trilha da Samaúma Milenar',
    category: 'trilhas',
    providerName: 'Marcos Apurinã',
    providerRole: 'guia',
    price: 90,
    priceUnit: 'por pessoa',
    rating: 4.8,
    reviews: 31,
    image: 'https://images.pexels.com/photos/13809456/pexels-photo-13809456.jpeg?auto=compress&cs=tinysrgb&h=650&w=940',
    community: 'Comunidade Apurinã',
    duration: '3 Horas',
    maxCapacity: 'Até 10 pessoas',
    passportStamps: '+3 Selos Culturais',
    description:
      'Caminhada guiada pela mata de terra firme até a grande Samaúma centenária. Conhecimentos tradicionais sobre plantas medicinais, fauna e histórias do povo Apurinã.',
    providerAvatar: 'https://images.pexels.com/photos/17060527/pexels-photo-17060527.jpeg?auto=compress&cs=tinysrgb&h=400&w=400',
    providerRoleTitle: 'Guia de Ecoturismo • Cadastur Verificado',
    providerBadge: '12 anos guiando trilhas na floresta',
  },
  {
    id: 'exp-biojoias',
    title: 'Biojoias em Sementes de Jarina',
    category: 'artesanato',
    providerName: 'Dona Zete',
    providerRole: 'artesa',
    price: 45,
    priceUnit: 'peça',
    rating: 5.0,
    reviews: 28,
    image: 'https://images.pexels.com/photos/10877371/pexels-photo-10877371.jpeg?auto=compress&cs=tinysrgb&h=650&w=940',
    community: 'Ateliê Ribeirinho',
    duration: '2 Horas',
    maxCapacity: 'Até 6 pessoas',
    passportStamps: '+1 Selo Cultural',
    description:
      'Oficina de biojoias com sementes da palmeira jarina. Aprendizado do fio, montagem e finalização de colares e pulseiras com técnicas tradicionais das artesãs ribeirinhas.',
    providerAvatar: 'https://images.pexels.com/photos/20454135/pexels-photo-20454135.jpeg?auto=compress&cs=tinysrgb&h=400&w=400',
    providerRoleTitle: 'Artesã Ribeirinha • Cooperativa do Rio Negro',
    providerBadge: '20 anos produzindo biojoias',
  },
  {
    id: 'exp-moqueado',
    title: 'Peixe Moqueado Tradicional',
    category: 'culinaria',
    providerName: 'Dona Antônia',
    providerRole: 'cozinheira',
    price: 45,
    priceUnit: 'refeição',
    rating: 4.9,
    reviews: 55,
    image: 'https://images.pexels.com/photos/29852479/pexels-photo-29852479.jpeg?auto=compress&cs=tinysrgb&h=650&w=940',
    community: 'Cozinha Tradicional',
    duration: '1.5 Horas',
    maxCapacity: 'Até 20 pessoas',
    passportStamps: '+1 Selo Cultural',
    description:
      'Refeição tradicional com peixe moqueado no folha de bananeira, acompanhado de farinha d\'água, tucumã e pirarucu defumado. Vivência gastronômica na cozinha comunitária.',
    providerAvatar: 'https://images.pexels.com/photos/10154688/pexels-photo-10154688.jpeg?auto=compress&cs=tinysrgb&h=400&w=400',
    providerRoleTitle: 'Cozinheira Regional • Cozinha Tradicional',
    providerBadge: '25 anos na culinária ribeirinha',
  },
];

export const seedBadges: Badge[] = [
  { id: 'b1', name: 'Guardião das Águas', description: 'Completou travessia fluvial com condutor local', earned: true, icon: 'waves' },
  { id: 'b2', name: 'Apoio ao Artesão', description: 'Comprou peça de artesã ribeirinha', earned: true, icon: 'hand-heart' },
  { id: 'b3', name: 'Protetor da Samaúma', description: 'Concluiu trilha na mata de terra firme', earned: false, icon: 'tree-pine' },
  { id: 'b4', name: 'Sabor da Floresta', description: 'Experimentou culinária tradicional local', earned: false, icon: 'utensils' },
  { id: 'b5', name: 'Guardião das Águas II', description: 'Fez 2 travessias fluviais', earned: false, icon: 'droplets' },
  { id: 'b6', name: 'Embaixador Comunitário', description: 'Visitou 3 experiências comunitárias', earned: false, icon: 'award' },
];

export const seedBoatTrips: BoatTrip[] = [
  { id: 'bt1', boat: 'Voadeira Rio Negro II', route: 'Manaus → Tumbira', departure: '08:30', maxCapacity: 10, booked: 6, pricePerSeat: 120 },
  { id: 'bt2', boat: 'Voadeira Rio Negro II', route: 'Tumbira → Comunidade Catalão', departure: '14:00', maxCapacity: 8, booked: 3, pricePerSeat: 90 },
];

export const seedTrails: Trail[] = [
  { id: 'tr1', name: 'Trilha das Samaúmas', level: 'Moderada', duration: '3h', gps: '-3.0831°, -60.0512°', maxPeople: 10 },
  { id: 'tr2', name: 'Vivência Casa de Farinha', level: 'Leve', duration: '1h30', gps: '-3.0902°, -60.0418°', maxPeople: 8 },
];

export const seedCrafts: CraftItem[] = [
  { id: 'cr1', name: 'Colar Jarina Natural', material: 'Sementes Naturais', quantity: 5, price: 45, image: 'https://images.pexels.com/photos/10877371/pexels-photo-10877371.jpeg?auto=compress&cs=tinysrgb&h=400&w=400' },
  { id: 'cr2', name: 'Pulseira Fibra de Arumã', material: 'Fibra de Arumã', quantity: 9, price: 25, image: 'https://images.pexels.com/photos/27067283/pexels-photo-27067283.jpeg?auto=compress&cs=tinysrgb&h=400&w=400' },
];

export const seedMeals: Meal[] = [
  { id: 'ml1', type: 'Almoço da Floresta', name: 'Peixe Moqueado com Farinha', window: '11:30 - 13:30', maxPortions: 20, reserved: 14, price: 45 },
  { id: 'ml2', type: 'Café Regional', name: 'Café com Tucumã e Bolo de Macaxeira', window: '06:00 - 08:00', maxPortions: 15, reserved: 8, price: 20 },
];

export const defaultData: AppData = {
  currentRole: 'turista',
  theme: 'light',
  isLoggedIn: false,
  experiences: seedExperiences,
  vouchers: [],
  badges: seedBadges,
  boatTrips: seedBoatTrips,
  trails: seedTrails,
  crafts: seedCrafts,
  meals: seedMeals,
  selectedExperienceId: null,
  missionsCompleted: 4,
  missionsTotal: 6,
};
