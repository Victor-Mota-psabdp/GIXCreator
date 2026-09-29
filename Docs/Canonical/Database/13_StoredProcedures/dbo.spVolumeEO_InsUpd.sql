SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--SELECT * FROM VOLUME_Exp_OUT


CREATE	procedure [dbo].[spVolumeEO_InsUpd]
			
@Num_Proc_HEO	varchar(16),
@Item_EO 	varchar(2),
@Qtd_Vol_EO	Float, 
@Embalagem	varchar(30),
@Compr_EO	Float,
@Largura_EO	Float,
@Altura_EO	Float,
@Peso_Bruto_EO	Float,
@NCM		varchar(8),
@Marca_EO	varchar(200),
@Contra_Marca	varchar(200),
@Volume		Float

AS

BEGIN TRANSACTION

Declare @cd_tp_embal 	varchar(3)
Declare @Id_NCM		int
 
set @cd_tp_embal = (select cd_tp_embal from tipo_embalagem where nome_tp_embal = @Embalagem)
set @Id_NCM = (select id_ncm from NCM where ncm = @NCM)
	if exists (select Item_EO from Volume_Exp_OUT where Item_EO = @Item_EO and Num_Proc_HEO = @Num_Proc_HEO)
		BEGIN
			UPDATE
				Volume_Exp_OUT
			SET
				Qtd_Vol_EO	=@Qtd_Vol_EO,
				Cd_Tp_Embal	=@Cd_Tp_Embal,
				Compr_EO	=@Compr_EO,
				Largura_EO	=@Largura_EO,
				Altura_EO	=@Altura_EO,
				Peso_Bruto_EO	=@Peso_Bruto_EO,
				Id_NCM		=@Id_NCM,
				Marca_EO	=@Marca_EO,
				Contra_Marca	=@Contra_Marca,
				Vol_Item_EO	=@Volume,
				cd_tp_unidade	='M3'
			WHERE
				Item_EO = @Item_EO and Num_Proc_HEO = @Num_Proc_HEO
		END
	ELSE
		BEGIN
			SET @Item_EO=(select Isnull(max(Item_EO),0)+1 from Volume_Exp_OUT where Num_Proc_HEO=@Num_Proc_HEO )
			SET @Item_EO = '0'+@Item_EO
			SET @Item_EO = right(@Item_EO,2)
			INSERT INTO
				Volume_Exp_OUT
				(
					Num_Proc_HEO,
					Item_EO,
					Qtd_Vol_EO,
					Cd_Tp_Embal,
					Compr_EO,
					Largura_EO,
					Altura_EO,
					Peso_Bruto_EO,
					Id_NCM,
					Marca_EO,
					Contra_Marca,
					Vol_Item_EO,
					cd_tp_unidade
				)
			VALUES
				(
					@Num_Proc_HEO,
					@Item_EO,
					@Qtd_Vol_EO,
					@Cd_Tp_Embal,
					@Compr_EO,
					@Largura_EO,
					@Altura_EO,
					@Peso_Bruto_EO,
					@Id_NCM,
					@Marca_EO,
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
