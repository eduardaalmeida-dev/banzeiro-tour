import { useApp } from '../store';
import { AppBar } from '../components/AppBar';
import { Button } from '../components/Button';
import { Star, Clock, Users, Stamp, Shield, BadgeCheck, Wallet, Waves } from 'lucide-react';

export function DetailScreen() {
  const { data, setScreen, addVoucher } = useApp();
  const exp = data.experiences.find((e) => e.id === data.selectedExperienceId);

  if (!exp) {
    return (
      <div className="flex items-center justify-center min-h-full">
        <p className="text-gray-400">Experiência não encontrada</p>
      </div>
    );
  }

  const handleBook = () => {
    const code = `BNZ-${Math.floor(1000 + Math.random() * 9000)}`;
    const uuid = `${crypto.randomUUID()}`;
    addVoucher({
      id: crypto.randomUUID(),
      code,
      uuid,
      experienceTitle: exp.title,
      date: '19/09/2026',
      time: '08:30 AM',
      boat: exp.boat || 'Embarcação Comunitária',
      passengers: '2 Adultos',
      experienceId: exp.id,
    });
    setScreen('voucher');
  };

  return (
    <div className="flex flex-col min-h-full bg-[#F8FAF8] dark:bg-primary-900 pb-24">
      <AppBar
        showBack
        showShare
        onBack={() => setScreen('catalog')}
        onShare={() => {}}
      />

      <div className="flex-1 overflow-y-auto no-scrollbar">
        {/* Hero image */}
        <div className="relative h-56 overflow-hidden">
          <img src={exp.image} alt={exp.title} className="w-full h-full object-cover" />
          <div className="absolute inset-0 bg-gradient-to-t from-black/40 to-transparent" />
          <div className="absolute bottom-3 left-4 bg-primary-600/90 backdrop-blur-sm rounded-full px-3 py-1.5">
            <span className="text-xs font-bold text-white">{exp.community}</span>
          </div>
        </div>

        <div className="px-5 py-5 space-y-5">
          {/* Title & price */}
          <div>
            <h1 className="font-heading text-xl font-extrabold text-primary-700 dark:text-white leading-tight mb-2">
              {exp.title}
            </h1>
            <p className="font-heading text-2xl font-extrabold text-accent-600 dark:text-accent-300">
              R$ {exp.price},00
              <span className="text-sm font-medium text-gray-400 dark:text-gray-500 ml-1">
                {exp.priceUnit}
              </span>
            </p>
          </div>

          {/* Quick specs grid */}
          <div className="grid grid-cols-3 gap-3">
            <div className="bg-white dark:bg-surface-dark rounded-2xl p-3 text-center border border-gray-100 dark:border-primary-800">
              <Clock size={20} className="text-accent-500 mx-auto mb-1.5" />
              <p className="text-[10px] text-gray-400 dark:text-gray-500 font-semibold uppercase">Duração</p>
              <p className="text-xs font-bold text-primary-700 dark:text-white">{exp.duration}</p>
            </div>
            <div className="bg-white dark:bg-surface-dark rounded-2xl p-3 text-center border border-gray-100 dark:border-primary-800">
              <Users size={20} className="text-accent-500 mx-auto mb-1.5" />
              <p className="text-[10px] text-gray-400 dark:text-gray-500 font-semibold uppercase">Vagas</p>
              <p className="text-xs font-bold text-primary-700 dark:text-white">{exp.maxCapacity}</p>
            </div>
            <div className="bg-white dark:bg-surface-dark rounded-2xl p-3 text-center border border-gray-100 dark:border-primary-800">
              <Stamp size={20} className="text-accent-500 mx-auto mb-1.5" />
              <p className="text-[10px] text-gray-400 dark:text-gray-500 font-semibold uppercase">Selos</p>
              <p className="text-xs font-bold text-primary-700 dark:text-white">{exp.passportStamps}</p>
            </div>
          </div>

          {/* Description */}
          <div>
            <h3 className="font-heading font-bold text-sm text-primary-700 dark:text-white mb-2">
              Sobre a experiência
            </h3>
            <p className="text-sm text-gray-600 dark:text-gray-300 leading-relaxed">
              {exp.description}
            </p>
          </div>

          {/* Provider card */}
          <div className="bg-white dark:bg-surface-dark rounded-2xl p-4 border border-gray-100 dark:border-primary-800">
            <div className="flex items-start gap-3 mb-4">
              <img
                src={exp.providerAvatar}
                alt={exp.providerName}
                className="w-16 h-16 rounded-2xl object-cover shrink-0"
              />
              <div className="flex-1 min-w-0">
                <h3 className="font-heading font-bold text-sm text-primary-700 dark:text-white">
                  {exp.providerName}
                </h3>
                <p className="text-xs text-gray-500 dark:text-gray-400 mt-0.5">
                  {exp.providerRoleTitle}
                </p>
                <div className="inline-flex items-center gap-1 mt-2 bg-accent-50 dark:bg-accent-900/30 rounded-full px-2.5 py-1">
                  <BadgeCheck size={12} className="text-accent-500" />
                  <span className="text-[10px] font-bold text-accent-600 dark:text-accent-300">
                    {exp.providerBadge}
                  </span>
                </div>
              </div>
            </div>

            {/* Direct income banner */}
            <div className="bg-accent-50 dark:bg-accent-900/20 rounded-xl p-3 flex items-start gap-2.5 mb-4">
              <Wallet size={18} className="text-accent-600 dark:text-accent-300 mt-0.5 shrink-0" />
              <p className="text-xs text-accent-700 dark:text-accent-200 font-medium leading-relaxed">
                100% do valor desta reserva vai diretamente para a família do prestador sem
                intermediários abusivos. Alinhado ao ODS 8.9.
              </p>
            </div>

            {/* Reputation */}
            <div className="flex items-center gap-2 pt-3 border-t border-gray-100 dark:border-primary-800">
              <div className="flex items-center gap-1">
                <Star size={16} className="text-warning-500 fill-warning-500" />
                <span className="font-bold text-sm text-primary-700 dark:text-white">
                  {exp.rating}
                </span>
              </div>
              <span className="text-xs text-gray-400 dark:text-gray-500">
                ({exp.reviews} avaliações de ecoturistas)
              </span>
              <Shield size={14} className="ml-auto text-accent-500" />
              <span className="text-xs font-semibold text-accent-600 dark:text-accent-300">
                Verificado
              </span>
            </div>
          </div>
        </div>
      </div>

      {/* Fixed checkout bar */}
      <div className="fixed bottom-0 left-0 right-0 max-w-[420px] mx-auto bg-white dark:bg-surface-dark border-t border-gray-100 dark:border-primary-800 px-5 py-4 pb-6 z-40">
        <div className="flex items-center justify-between gap-4">
          <div>
            <p className="text-xs text-gray-400 dark:text-gray-500 font-semibold">Total</p>
            <p className="font-heading text-xl font-extrabold text-primary-700 dark:text-white">
              R$ {exp.price * 2},00
            </p>
          </div>
          <Button variant="accent" size="lg" onClick={handleBook} icon={<Waves size={18} />}>
            Agendar Experiência Direta
          </Button>
        </div>
      </div>
    </div>
  );
}
