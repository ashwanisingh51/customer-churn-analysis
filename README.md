# Customer Churn Analysis: Identifying and Preventing Revenue Loss

## Executive Summary

Analyzed 50,000+ customer transaction records to identify the top drivers of customer churn. Discovered that **payment velocity** (speed of first purchase) is 3X more predictive of churn than tenure or spending amount.

**Key Finding:** Customers with payment velocity < 2 days have 8% churn rate. Customers with payment velocity > 14 days have 58% churn rate.

**Business Impact:** Recommended behavior-based retention strategy targeting at-risk segments. Estimated **$240K-300K annual revenue preservation** for a $50M ARR business.

---

## The Problem

E-commerce and fintech companies lose 15-25% of customers annually. Most don't understand why, so retention strategies are random guesses that waste budget.

Traditional assumption: "Older customers are more loyal."

Reality: This assumption is wrong.

---

## The Analysis

### Data
- **Period:** May 2025 - April 2026
- - **Records:** 50,000+ customers
  - - **Variables:** 30+ (payment behavior, frequency, engagement, tenure, spending, geography, etc.)
    - - **Tools:** Python (Pandas, NumPy, Scikit-learn), SQL, statistical testing
     
      - ### Key Findings
     
      - **1. Payment Velocity is the #1 Churn Driver**
     
      - Customers who pay within 2 days: 8% churn rate
      - Customers who pay after 14 days: 58% churn rate
      - Statistical significance: p-value < 0.01, 98% confidence
     
      - **2. Secondary Drivers**
      - - Engagement velocity (time to second purchase): 1.8X impact
        - - Customer support interactions in first 30 days: 1.5X impact
          - - Geographic region: 1.2X impact
           
            - **3. Tenure is NOT a Strong Predictor**
            - - Customers at 6 months: 12% churn rate
              - - Customers at 12 months: 10% churn rate
                - - Difference: only 2%
                 
                  - ---

                  ## The Recommendation

                  **Immediate Actions:**
                  1. Accelerate onboarding - Get 80% of customers to first payment within 48 hours
                  2. 2. Target at-risk segment - Identify customers with payment velocity > 10 days
                     3. 3. Automate monitoring - Flag new customers not paying by Day 5
                       
                        4. **Expected Impact:**
                        5. - Churn reduction: 8-12%
                           - - Revenue preservation: $240K-300K annually
                             - - Payback period: < 6 months
                              
                               - ---

                               ## Technical Details

                               ### Model Performance
                               - Algorithm: XGBoost classifier
                               - - Training set: 35,000 customers
                                 - - Test set: 15,000 customers
                                   - - AUC: 0.89
                                     - - Precision: 0.84
                                       - - Recall: 0.81
                                        
                                         - ### Methodology
                                         - 1. Data cleaning - Removed duplicates, handled missing values
                                           2. 2. Feature engineering - Created 15+ derived features
                                              3. 3. Correlation analysis - Ranked variables by predictive power
                                                 4. 4. Model training - Tested multiple algorithms, XGBoost performed best
                                                    5. 5. Validation - Holdout set + 5-fold cross-validation
                                                      
                                                       6. ---
                                                      
                                                       7. ## Files in This Repo
                                                      
                                                       8. - churn_analysis.ipynb - Full Jupyter notebook
                                                          - - data_extraction.sql - SQL queries for data extraction
                                                            - - churn_dashboard_screenshot.png - Power BI dashboard
                                                              - - README.md - This file
                                                               
                                                                - ---

                                                                ## Key Takeaways

                                                                1. Payment velocity matters more than tenure
                                                                2. 2. Behavior is predictable - identify at-risk customers early
                                                                   3. 3. Retention beats acquisition
                                                                      4. 4. Data beats intuition
                                                                        
                                                                         5. For questions or discussion, reach out!
