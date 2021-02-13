"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const fs_1 = __importDefault(require("fs"));
const imagedata_1 = require("@andreekeberg/imagedata");
class ImageController {
    async index({ request, response }) {
        const { file, approved, percentage } = request.all();
        const buffer = Buffer.from(file.split(';base64,').pop(), 'base64');
        const fileName = "image-" + new Date().getTime() + ".jpg";
        const imgPath = "./public/" + fileName;
        fs_1.default.writeFileSync(imgPath, buffer);
        const image = await imagedata_1.getSync("./public/img.jpg");
        if (!image) {
            return response.status(400).json({ message: "Imagem não enviada" });
        }
        return response.json({ message: 'Imagem salva com sucesso', path: fileName, approved, percentage: percentage * 100 });
    }
}
exports.default = ImageController;
//# sourceMappingURL=ImageController.js.map