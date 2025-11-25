// Theme toggle and small screenshot carousel
(function(){
  const body = document.body;
  const toggle = document.getElementById('theme-toggle');
  const logo = document.getElementById('logo-img');

  // Set initial theme based on prefers-color-scheme
  const prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
  if(prefersDark){ body.classList.remove('light'); body.classList.add('dark'); setDarkImages(); }

  toggle.addEventListener('click', ()=>{
    if(body.classList.contains('dark')){ body.classList.remove('dark'); body.classList.add('light'); setLightImages(); }
    else{ body.classList.remove('light'); body.classList.add('dark'); setDarkImages(); }
  });

  function setDarkImages(){
    logo.src = 'assets/aura_os_dark.png';
    document.querySelectorAll('.screen-img').forEach(img=> img.src = 'assets/aura_os_dark.png');
  }
  function setLightImages(){
    logo.src = 'assets/aura_os_light.png';
    document.querySelectorAll('.screen-img').forEach(img=> img.src = 'assets/aura_os_light.png');
  }

  // device mockup carousel (one at a time)
  const carousel = document.getElementById('carousel');
  const dotsContainer = document.getElementById('dots-container');
  const prevBtn = document.getElementById('prev-btn');
  const nextBtn = document.getElementById('next-btn');
  
  if(carousel){
    const frames = Array.from(carousel.querySelectorAll('.device-frame'));
    let currentIdx = 0;
    
    // Create dots
    frames.forEach((_, i)=>{
      const dot = document.createElement('div');
      dot.className = 'dot' + (i === 0 ? ' active' : '');
      dot.addEventListener('click', ()=> goToSlide(i));
      dotsContainer.appendChild(dot);
    });
    
    function updateSlide(){
      frames.forEach((frame, i)=> {
        frame.classList.toggle('active', i === currentIdx);
      });
      dotsContainer.querySelectorAll('.dot').forEach((dot, i)=> dot.classList.toggle('active', i === currentIdx));
    }
    
    function goToSlide(idx){
      currentIdx = idx;
      updateSlide();
    }
    
    prevBtn.addEventListener('click', ()=>{
      currentIdx = (currentIdx - 1 + frames.length) % frames.length;
      updateSlide();
    });
    
    nextBtn.addEventListener('click', ()=>{
      currentIdx = (currentIdx + 1) % frames.length;
      updateSlide();
    });
    
    // Auto-rotate every 4 seconds
    setInterval(()=>{
      currentIdx = (currentIdx + 1) % frames.length;
      updateSlide();
    }, 4000);
  }

})();
