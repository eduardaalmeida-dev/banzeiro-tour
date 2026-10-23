import type { ReactNode } from 'react';
import { ChevronLeft, Share2 } from 'lucide-react';

interface AppBarProps {
  title?: string;
  showBack?: boolean;
  showShare?: boolean;
  onBack?: () => void;
  onShare?: () => void;
  rightSlot?: ReactNode;
}

export function AppBar({ title, showBack, showShare, onBack, onShare, rightSlot }: AppBarProps) {
  return (
    <div className="sticky top-0 z-30 bg-white/95 dark:bg-surface-dark/95 backdrop-blur-md border-b border-gray-100 dark:border-primary-800 px-4 py-3 flex items-center gap-3">
      {showBack && (
        <button
          onClick={onBack}
          className="flex items-center gap-1 text-primary-600 dark:text-accent-300 font-semibold text-sm min-h-[40px]"
        >
          <ChevronLeft size={20} />
          Voltar
        </button>
      )}
      {title && (
        <h2 className="font-heading font-bold text-base text-primary-700 dark:text-white flex-1 truncate">
          {title}
        </h2>
      )}
      <div className="flex items-center gap-2 ml-auto">
        {rightSlot}
        {showShare && (
          <button
            onClick={onShare}
            className="flex items-center justify-center w-10 h-10 rounded-full bg-gray-100 dark:bg-primary-800 text-primary-600 dark:text-accent-300 hover:bg-gray-200 dark:hover:bg-primary-700 transition-colors"
          >
            <Share2 size={18} />
          </button>
        )}
      </div>
    </div>
  );
}
