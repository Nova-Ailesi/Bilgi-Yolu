import React, { useState, useEffect } from 'react';
import { X, ChevronLeft, ChevronRight, Lightbulb, Bookmark } from 'lucide-react';
import { Story } from '../types';

interface StoriesViewProps {
  stories: Story[];
  onClose: () => void;
}

export const StoriesView: React.FC<StoriesViewProps> = ({ stories, onClose }) => {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [progress, setProgress] = useState(0);

  const currentStory = stories[currentIndex];

  useEffect(() => {
    setProgress(0);
    const interval = setInterval(() => {
      setProgress((prev) => {
        if (prev >= 100) {
          handleNext();
          return 0;
        }
        return prev + 2;
      });
    }, 100);

    return () => clearInterval(interval);
  }, [currentIndex]);

  const handleNext = () => {
    if (currentIndex < stories.length - 1) {
      setCurrentIndex((prev) => prev + 1);
      setProgress(0);
    } else {
      onClose();
    }
  };

  const handlePrev = () => {
    if (currentIndex > 0) {
      setCurrentIndex((prev) => prev - 1);
      setProgress(0);
    }
  };

  return (
    <div className="fixed inset-0 z-50 bg-black flex items-center justify-center p-0 sm:p-4">
      <div
        className="relative w-full max-w-md h-full sm:h-[640px] rounded-none sm:rounded-3xl overflow-hidden flex flex-col justify-between p-6 shadow-2xl"
        style={{
          backgroundColor: currentStory.color || '#002366',
        }}
      >
        {/* Üst İlerleme Çubukları */}
        <div className="space-y-3 z-10">
          <div className="flex items-center gap-1.5 w-full">
            {stories.map((_, idx) => (
              <div
                key={idx}
                className="flex-1 bg-white/30 h-1 rounded-full overflow-hidden"
              >
                <div
                  className="bg-white h-1 transition-all duration-100"
                  style={{
                    width:
                      idx < currentIndex
                        ? '100%'
                        : idx === currentIndex
                        ? `${progress}%`
                        : '0%',
                  }}
                />
              </div>
            ))}
          </div>

          <div className="flex items-center justify-between text-white">
            <span className="bg-white/20 backdrop-blur-md px-3 py-1 rounded-full text-xs font-bold">
              {currentStory.category}
            </span>
            <button
              onClick={onClose}
              className="p-1 rounded-full bg-black/30 hover:bg-black/50 text-white transition-colors cursor-pointer"
            >
              <X className="w-5 h-5" />
            </button>
          </div>
        </div>

        {/* Ana İçerik Kartı */}
        <div className="my-auto text-center space-y-4 px-2 z-10">
          <div className="w-16 h-16 mx-auto rounded-2xl bg-white/15 backdrop-blur-md flex items-center justify-center text-amber-300 shadow-lg border border-white/20">
            <Lightbulb className="w-8 h-8" />
          </div>

          <h3 className="text-2xl font-black text-white tracking-tight">
            {currentStory.title}
          </h3>

          <div className="bg-white text-slate-900 p-6 rounded-2xl shadow-xl text-left text-sm leading-relaxed whitespace-pre-line font-medium border border-white/40">
            {currentStory.content}
          </div>
        </div>

        {/* Alt Navigasyon & Dokunma Alanları */}
        <div className="z-10 text-center text-xs text-white/70">
          İlerlemek için sağa, önceki için sola dokunun
        </div>

        {/* Görünmez Tıklama Alanları */}
        <div
          onClick={handlePrev}
          className="absolute inset-y-0 left-0 w-1/3 cursor-pointer z-0"
        />
        <div
          onClick={handleNext}
          className="absolute inset-y-0 right-0 w-2/3 cursor-pointer z-0"
        />
      </div>
    </div>
  );
};
