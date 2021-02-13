
import { HttpContextContract } from '@ioc:Adonis/Core/HttpContext';
import fs from 'fs';
import { getSync } from '@andreekeberg/imagedata';

export default class ImageController {

    public async index({request  , response} : HttpContextContract){
        const {file, approved, percentage} = request.all();
        const buffer = Buffer.from(file.split(';base64,').pop(),'base64');
        const fileName = "image-"+new Date().getTime()+".jpg";

        const imgPath = "./public/"+fileName;
        fs.writeFileSync(imgPath, buffer);

        const image = await getSync("./public/img.jpg");

        if(!image){
            return response.status(400).json({message: "Imagem não enviada"});
        }
        
        return response.json({message: 'Imagem salva com sucesso' , path: fileName, approved, percentage : percentage * 100});
    }

}
