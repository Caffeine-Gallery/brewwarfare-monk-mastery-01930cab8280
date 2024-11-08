import { backend } from "declarations/backend";

const showLoading = () => {
    document.getElementById('loading').classList.remove('d-none');
};

const hideLoading = () => {
    document.getElementById('loading').classList.add('d-none');
};

const formatContent = (text) => {
    return text.split('\n').map(line => {
        if (line.trim().startsWith('-')) {
            return `<li>${line.substring(1).trim()}</li>`;
        }
        if (line.match(/^\d+\./)) {
            return `<li>${line.substring(line.indexOf('.') + 1).trim()}</li>`;
        }
        if (line.trim() === '') {
            return '<br>';
        }
        if (line.trim().endsWith(':')) {
            return `<h4 class="mt-3">${line}</h4>`;
        }
        return `<p>${line}</p>`;
    }).join('');
};

const loadSection = async (sectionId) => {
    try {
        console.log(`Loading section: ${sectionId}`);
        const content = await backend.getSection(sectionId);
        if (content) {
            console.log(`Content received for ${sectionId}`);
            const container = document.querySelector(`#${sectionId} .content-section`);
            if (container) {
                if (sectionId === 'stats' || sectionId === 'single_target' || 
                    sectionId === 'aoe' || sectionId === 'cooldowns' || 
                    sectionId === 'utilities') {
                    container.innerHTML = formatContent(content);
                } else {
                    container.innerHTML = formatContent(content);
                }
            }
        } else {
            console.error(`No content received for section: ${sectionId}`);
        }
    } catch (error) {
        console.error(`Error loading ${sectionId}:`, error);
    }
};

const initializeGuide = async () => {
    showLoading();
    try {
        const sections = ['talents', 'stats', 'single_target', 'aoe', 'cooldowns', 'utilities'];
        await Promise.all(sections.map(section => loadSection(section)));
    } catch (error) {
        console.error('Error initializing guide:', error);
    } finally {
        hideLoading();
    }
};

document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const section = document.querySelector(this.getAttribute('href'));
        if (section) {
            section.scrollIntoView({
                behavior: 'smooth'
            });
        }
    });
});

window.addEventListener('load', initializeGuide);
