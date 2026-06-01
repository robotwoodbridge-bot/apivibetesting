const express = require('express');
const cors = require('cors');
const swaggerJsdoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');

const authRoutes = require('./routes/auth');
const productRoutes = require('./routes/products');
const cartRoutes = require('./routes/cart');
const orderRoutes = require('./routes/orders');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// OpenAPI spec definition
const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'TechShop API',
      version: '1.0.0',
      description: 'REST API for TechShop e-commerce store — used in the Vibetesting API Testing course'
    },
    servers: [
      { url: 'http://localhost:3000', description: 'Local development server' }
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT'
        }
      },
      schemas: {
        Product: {
          type: 'object',
          properties: {
            id: { type: 'integer', example: 1 },
            name: { type: 'string', example: 'Laptop Pro 15"' },
            description: { type: 'string' },
            price: { type: 'number', format: 'float', example: 1299.99 },
            category: { type: 'string', example: 'computers' },
            stock: { type: 'integer', example: 10 },
            inStock: { type: 'boolean', example: true }
          }
        },
        CartItem: {
          type: 'object',
          properties: {
            id: { type: 'integer' },
            productId: { type: 'integer', example: 1 },
            name: { type: 'string', example: 'Laptop Pro 15"' },
            price: { type: 'number', example: 1299.99 },
            quantity: { type: 'integer', example: 2 }
          }
        },
        Cart: {
          type: 'object',
          properties: {
            items: {
              type: 'array',
              items: { '$ref': '#/components/schemas/CartItem' }
            },
            total: { type: 'number', example: 2599.98 }
          }
        },
        Order: {
          type: 'object',
          properties: {
            id: { type: 'string', example: 'ORD-1716000000000' },
            userId: { type: 'integer', example: 1 },
            items: { type: 'array', items: { type: 'object' } },
            shipping: { type: 'object' },
            payment: {
              type: 'object',
              properties: {
                last4: { type: 'string', example: '1111' },
                expiryDate: { type: 'string', example: '12/28' }
              }
            },
            total: { type: 'number', example: 1299.99 },
            status: { type: 'string', example: 'confirmed' },
            createdAt: { type: 'string', format: 'date-time' }
          }
        }
      }
    }
  },
  apis: ['./routes/*.js']
};

const swaggerSpec = swaggerJsdoc(swaggerOptions);

app.use('/docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));
app.get('/swagger.json', (req, res) => res.json(swaggerSpec));

// Routes
app.use('/auth', authRoutes);
app.use('/products', productRoutes);
app.use('/cart', cartRoutes);
app.use('/orders', orderRoutes);

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', version: '1.0.0', environment: 'fixed' });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: `Route ${req.method} ${req.path} not found` });
});

// Global error handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Internal server error' });
});

app.listen(PORT, () => {
  console.log(`TechShop API (fixed) running on http://localhost:${PORT}`);
  console.log(`Swagger UI: http://localhost:${PORT}/docs`);
  console.log(`OpenAPI spec: http://localhost:${PORT}/swagger.json`);
});

module.exports = app;
