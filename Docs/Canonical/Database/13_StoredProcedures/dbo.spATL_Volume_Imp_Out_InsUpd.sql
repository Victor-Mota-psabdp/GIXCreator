SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE	procedure [dbo].[spATL_Volume_Imp_Out_InsUpd]
		
@Num_Proc	    varchar(16),
@Item       	varchar(2),
@Qtd_Vol	    Float, 
@Embalagem	    varchar(30),
@Comprimento	Float,
@Largura  	    Float,
@Altura	        Float,
@Peso_Bruto	    Float,
@NCM		    varchar(8),
@Marca	        varchar(2000),
@Contra_Marca	varchar(2000),
@Volume		    Float

AS

BEGIN TRANSACTION

Declare @cd_tp_embal 	varchar(3)
Declare @Id_NCM		int
 
set @cd_tp_embal = (select cd_tp_embal from tipo_embalagem where nome_tp_embal = @Embalagem)
set @Id_NCM = (select id_ncm from NCM where ncm = @NCM)
	if exists (select Item_IO from Volume_Imp_OUT where Item_IO = @Item and Num_Proc_HIO = @Num_Proc)
		BEGIN
			UPDATE
				Volume_Imp_OUT
			SET
				Qtd_Vol_IO  	=@Qtd_Vol,
				Cd_Tp_Embal  	=@Cd_Tp_Embal,
				Compr_IO   	    =@Comprimento,
				Largura_IO	    =@Largura,
				Altura_IO	    =@Altura,
				Peso_Bruto_IO	=@Peso_Bruto,
				Id_NCM		    =@Id_NCM,
				Marca_IO	    =@Marca,
				Contra_Marca	=@Contra_Marca,
				Vol_Item_IO   	=@Volume,
				cd_tp_unidade	='M3'
			WHERE
				Item_IO = @Item and Num_Proc_HIO = @Num_Proc
		END
	ELSE
		BEGIN
			SET @Item=(select Isnull(max(Item_IO),0)+1 from Volume_Imp_OUT where Num_Proc_HIO=@Num_Proc)
			SET @Item = '0'+@Item
			SET @Item = right(@Item,2)
			INSERT INTO
				Volume_Imp_OUT
				(
					Num_Proc_HIO,
					Item_IO,
					Qtd_Vol_IO,
					Cd_Tp_Embal,
					Compr_IO,
					Largura_IO,
					Altura_IO,
					Peso_Bruto_IO,
					Id_NCM,
					Marca_IO,
					Contra_Marca,
					Vol_Item_IO,
					cd_tp_unidade
				)
			VALUES
				(
					@Num_Proc,
					@Item,
					@Qtd_Vol,
					@Cd_Tp_Embal,
					@Comprimento,
					@Largura,
					@Altura,
					@Peso_Bruto,
					@Id_NCM,
					@Marca,
					@Contra_Marca,
					@Volume,
					'M3'
				)
		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRANSACTION
	








GO
