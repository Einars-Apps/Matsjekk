document.addEventListener('DOMContentLoaded', function() {
    const barcodeInput = document.getElementById('barcode-input');
    const scanBtn = document.getElementById('scan-btn');
    const resultBox = document.getElementById('result');

    // Mock database of products (in a real app, this would be an API call)
    const products = {
        '7311041020883': {
            name: 'Tine Lettmelk',
            brand: 'Tine',
            category: 'Meieriprodukter',
            nutrition: {
                calories: '46 kcal',
                protein: '3.4g',
                carbs: '4.9g',
                fat: '1.5g'
            },
            allergens: ['Melk']
        },
        '7311041004074': {
            name: 'Tine Yoghurt Naturell',
            brand: 'Tine',
            category: 'Yoghurt',
            nutrition: {
                calories: '69 kcal',
                protein: '4.2g',
                carbs: '4.5g',
                fat: '3.5g'
            },
            allergens: ['Melk']
        },
        '123456789': {
            name: 'Eksempel Produkt',
            brand: 'Test Brand',
            category: 'Test',
            nutrition: {
                calories: '100 kcal',
                protein: '5g',
                carbs: '10g',
                fat: '2g'
            },
            allergens: ['Gluten', 'Melk']
        }
    };

    function scanBarcode() {
        const barcode = barcodeInput.value.trim();
        
        if (!barcode) {
            showResult('⚠️ Vennligst skriv inn en strekkode', 'warning');
            return;
        }

        const product = products[barcode];

        if (product) {
            displayProductInfo(product);
        } else {
            showResult(`
                <h4>❌ Produkt ikke funnet</h4>
                <p>Strekkode: ${barcode}</p>
                <p>Dette produktet finnes ikke i databasen ennå.</p>
                <p><em>Tips: Prøv strekkode "7311041020883", "7311041004074" eller "123456789"</em></p>
            `, 'error');
        }
    }

    function displayProductInfo(product) {
        const allergensList = product.allergens.join(', ');
        
        const html = `
            <h4>✅ ${product.name}</h4>
            <p><strong>Merkevare:</strong> ${product.brand}</p>
            <p><strong>Kategori:</strong> ${product.category}</p>
            
            <h5 style="margin-top: 1rem; color: #667eea;">Næringsinnhold (per 100g):</h5>
            <ul style="list-style: none; padding-left: 0;">
                <li>🔥 Kalorier: ${product.nutrition.calories}</li>
                <li>💪 Protein: ${product.nutrition.protein}</li>
                <li>🍞 Karbohydrater: ${product.nutrition.carbs}</li>
                <li>🧈 Fett: ${product.nutrition.fat}</li>
            </ul>
            
            <h5 style="margin-top: 1rem; color: #667eea;">Allergener:</h5>
            <p style="color: #e74c3c; font-weight: bold;">${allergensList}</p>
        `;
        
        showResult(html, 'success');
    }

    function showResult(content, type) {
        resultBox.innerHTML = content;
        resultBox.className = 'result-box show';
        
        if (type === 'success') {
            resultBox.style.borderLeft = '5px solid #2ecc71';
        } else if (type === 'error') {
            resultBox.style.borderLeft = '5px solid #e74c3c';
        } else {
            resultBox.style.borderLeft = '5px solid #f39c12';
        }
    }

    // Event listeners
    scanBtn.addEventListener('click', scanBarcode);
    
    barcodeInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            scanBarcode();
        }
    });
});
