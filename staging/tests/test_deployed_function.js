// Test the deployed nutrition enrichment function
const fs = require('fs');

async function testDeployedFunction() {
  try {
    // Read the test payload
    const payload = JSON.parse(fs.readFileSync('smoke_test_payload.json', 'utf8'));
    
    console.log('Testing deployed nutrition enrichment function...');
    console.log('Payload:', JSON.stringify(payload, null, 2));
    
    const response = await fetch('https://myqhpmeprpaukgagktbn.supabase.co/functions/v1/nutrition_enrichment', {
      method: 'POST',
      headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im15cWhwbWVwcnBhdWtnYWdrdGJuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkzNzU1MTksImV4cCI6MjA2NDk1MTUxOX0.XIyR3nHQVU4G3LTTnmYunBf05edLXoDVgVW316a-O4g',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(payload)
    });
    
    const result = await response.json();
    
    console.log('\\n=== RESPONSE ===');
    console.log('Status:', response.status);
    console.log('Result:', JSON.stringify(result, null, 2));
    
    // Check if we got valid nutrition data
    if (result.items && result.items.length > 0) {
      const firstItem = result.items[0];
      const hasNutrition = firstItem.nutrition && (
        firstItem.nutrition.calories > 0 || 
        firstItem.nutrition.protein_g > 0 || 
        firstItem.nutrition.fat_g > 0 || 
        firstItem.nutrition.carbs_g > 0
      );
      
      console.log('\\n=== ANALYSIS ===');
      console.log('Has valid nutrition data:', hasNutrition);
      
      if (hasNutrition) {
        console.log('✅ SUCCESS: Function is working correctly!');
        console.log('Sample nutrition data:', firstItem.nutrition);
      } else {
        console.log('❌ FAILURE: Still getting null/zero values');
      }
    }
    
    // Create verifiable evidence artifact
    const timestamp = new Date();
    const formattedTimestamp = timestamp.toISOString().replace(/[:.]/g, '-');
    const evidenceFileName = `test_evidence_${formattedTimestamp}.json`;
    
    const evidence = {
      test_run_at: timestamp.toISOString(),
      test_name: "Nutrition Enrichment Smoke Test",
      test_payload: payload,
      response_status: response.status,
      response_body: result
    };
    
    fs.writeFileSync(evidenceFileName, JSON.stringify(evidence, null, 2));
    console.log(`\n✅ Evidence artifact created: ${evidenceFileName}`);
    
  } catch (error) {
    console.error('Error testing function:', error);
  }
}

testDeployedFunction(); 