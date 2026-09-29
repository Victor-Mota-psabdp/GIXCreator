SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--SELECT * FROM VOLUME_IMP_OUT


CREATE	procedure [dbo].[spVolumeIO_InsUpd]
			
@Num_Proc_HIO	varchar(16),
@Item_IO 	varchar(2),
@Qtd_Vol_IO	Float, 
@Embalagem	varchar(30),
@Compr_IO	Float,
@Largura_IO	Float,
@Altura_IO	Float,
@Peso_Bruto_IO	Float,
@NCM		varchar(8),
@Marca_IO	varchar(2000),
@Contra_Marca	varchar(2000),
@Volume		Float

AS

BEGIN TRANSACTION

Declare @cd_tp_embal 	varchar(3)
Declare @Id_NCM		int
 
set @cd_tp_embal = (select cd_tp_embal from tipo_embalagem where nome_tp_embal = @Embalagem)
set @Id_NCM = (select id_ncm from NCM where ncm = @NCM)
	if exists (select Item_IO from Volume_Imp_OUT where Item_IO = @Item_IO and Num_Proc_HIO = @Num_Proc_HIO)
		BEGIN
			UPDATE
				Volume_Imp_OUT
			SET
				Qtd_Vol_IO	=@Qtd_Vol_IO,
				Cd_Tp_Embal	=@Cd_Tp_Embal,
				Compr_IO	=@Compr_IO,
				Largura_IO	=@Largura_IO,
				Altura_IO	=@Altura_IO,
				Peso_Bruto_IO	=@Peso_Bruto_IO,
				Id_NCM		=@Id_NCM,
				Marca_IO	=@Marca_IO,
				Contra_Marca	=@Contra_Marca,
				Vol_Item_IO	=@Volume,
				cd_tp_unidade	='M3'
			WHERE
				Item_IO = @Item_IO and Num_Proc_HIO = @Num_Proc_HIO
		END
	ELSE
		BEGIN
			SET @Item_IO=(select Isnull(max(Item_IO),0)+1 from Volume_Imp_OUT where Num_Proc_HIO=@Num_Proc_HIO )
			SET @Item_IO = '0'+@Item_IO
			SET @Item_IO = right(@Item_IO,2)
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
					@Num_Proc_HIO,
					@Item_IO,
					@Qtd_Vol_IO,
					@Cd_Tp_Embal,
					@Compr_IO,
					@Largura_IO,
					@Altura_IO,
					@Peso_Bruto_IO,
					@Id_NCM,
					@Marca_IO,
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
