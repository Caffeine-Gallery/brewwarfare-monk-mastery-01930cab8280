import { backend } from "declarations/backend";

// Show loading spinner
const showLoading = () => {
    document.getElementById('loading').classList.remove('d-none');
};

// Hide loading spinner
const hideLoading = () => {
    document.getElementById('loading').classList.add('d-none');
};

// Convert plain text to HTML with line breaks
const formatContent = (text) => {
    return text.split('\n').map(line => {
        if (line.trim().startsWith('-')) {
            return `<li>${line.substring(1).trim()}</li>`;
        }
        if (line.match(/^\d+\./)) {
            return `<li>${line.substring(line.indexOf('.') + 1).trim()}</li>`;
        }
        return `<p>${line}</p>`;
    }).join('');
};

// Load content for a specific section
const loadSection = async (sectionId) => {
    try {
        const content = await backend.getSection(sectionId);
        if (content) {
            const container = document.querySelector(`#${sectionId} .content-section`);
            if (container) {
                if (sectionId === 'stats' || sectionId === 'single_target' || 
                    sectionId === 'aoe' || sectionId === 'cooldowns' || 
                    sectionId === 'utilities') {
                    container.innerHTML = `<ul>${formatContent(content)}</ul>`;
                } else {
                    container.innerHTML = formatContent(content);
                }
            }
        }
    } catch (error) {
        console.error(`Error loading ${sectionId}:`, error);
    }
};

// Initialize the guide
const initializeGuide = async () => {
    showLoading();
    try {
        // Load all sections
        const sections = ['talents', 'stats', 'single_target', 'aoe', 'cooldowns', 'utilities'];
        await Promise.all(sections.map(section => loadSection(section)));
    } catch (error) {
        console.error('Error initializing guide:', error);
    } finally {
        hideLoading();
    }
};

// Add smooth scrolling for navigation
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

// Initialize the guide when the page loads
window.addEventListener('load', initializeGuide);
