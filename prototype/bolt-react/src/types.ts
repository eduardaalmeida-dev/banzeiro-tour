export type Role = 'turista' | 'barqueiro' | 'guia' | 'artesa' | 'cozinheira';
export type Theme = 'light' | 'dark';
export type Category = 'todos' | 'barcos' | 'trilhas' | 'artesanato' | 'culinaria';

export type Screen =
  | 'login'
  | 'catalog'
  | 'detail'
  | 'voucher'
  | 'passport'
  | 'profile'
  | 'barqueiro'
  | 'boatTripForm'
  | 'guia'
  | 'trailForm'
  | 'artesa'
  | 'craftForm'
  | 'cozinheira'
  | 'mealForm';

export interface Experience {
  id: string;
  title: string;
  category: Exclude<Category, 'todos'>;
  providerName: string;
  providerRole: Role;
  price: number;
  priceUnit: string;
  rating: number;
  reviews: number;
  image: string;
  community: string;
  duration: string;
  maxCapacity: string;
  passportStamps: string;
  description: string;
  providerAvatar: string;
  providerRoleTitle: string;
  providerBadge: string;
  boat?: string;
}

export interface Voucher {
  id: string;
  code: string;
  uuid: string;
  experienceTitle: string;
  date: string;
  time: string;
  boat: string;
  passengers: string;
  experienceId: string;
}

export interface Badge {
  id: string;
  name: string;
  description: string;
  earned: boolean;
  icon: string;
}

export interface BoatTrip {
  id: string;
  boat: string;
  route: string;
  departure: string;
  maxCapacity: number;
  booked: number;
  pricePerSeat: number;
}

export interface Trail {
  id: string;
  name: string;
  level: 'Leve' | 'Moderada' | 'Selva Densa';
  duration: string;
  gps: string;
  maxPeople: number;
}

export interface CraftItem {
  id: string;
  name: string;
  material: string;
  quantity: number;
  price: number;
  image: string;
}

export interface Meal {
  id: string;
  type: string;
  name: string;
  window: string;
  maxPortions: number;
  reserved: number;
  price: number;
}

export interface AppData {
  currentRole: Role;
  theme: Theme;
  isLoggedIn: boolean;
  experiences: Experience[];
  vouchers: Voucher[];
  badges: Badge[];
  boatTrips: BoatTrip[];
  trails: Trail[];
  crafts: CraftItem[];
  meals: Meal[];
  selectedExperienceId: string | null;
  missionsCompleted: number;
  missionsTotal: number;
}
