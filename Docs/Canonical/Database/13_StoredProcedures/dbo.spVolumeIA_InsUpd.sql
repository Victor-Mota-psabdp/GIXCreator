SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--SELECT * FROM VOLUME_IMP_AER


CREATE	procedure [dbo].[spVolumeIA_InsUpd]
			
@Num_Proc_HIA	varchar(16),
@Item_IA 	varchar(2),
@Qtd_Vol_IA	Float, 
@Embalagem	varchar(30),
@Compr_IA	Float,
@Largura_IA	Float,
@Altura_IA	Float,
@Peso_Bruto_IA	Float,
@NCM		varchar(8),
@Marca_IA	varchar(2000),
@Contra_Marca	varchar(2000),
@Volume		Float

AS

BEGIN TRANSACTION

Declare @cd_tp_embal 	varchar(3)
Declare @Id_NCM		int
 
set @cd_tp_embal = (select cd_tp_embal from tipo_embalagem where nome_tp_embal = @Embalagem)
set @Id_NCM = (select id_ncm from NCM where ncm = @NCM)
	if exists (select Item_IA from Volume_Imp_Aer where Item_IA = @Item_IA and Num_Proc_HIA = @Num_Proc_HIA)
		BEGIN
			UPDATE
				Volume_Imp_Aer
			SET
				Qtd_Vol_IA	=@Qtd_Vol_IA,
				Cd_Tp_Embal	=@Cd_Tp_Embal,
				Compr_IA	=@Compr_IA,
				Largura_IA	=@Largura_IA,
				Altura_IA	=@Altura_IA,
				Peso_Bruto_IA	=@Peso_Bruto_IA,
				Id_NCM		=@Id_NCM,
				Marca_IA	=@Marca_IA,
				Contra_Marca	=@Contra_Marca,
				Vol_Item_IA	=@Volume,
				cd_tp_unidade	='M3'
			WHERE
				Item_IA = @Item_IA and Num_Proc_HIA = @Num_Proc_HIA
		END
	ELSE
		BEGIN
			SET @Item_IA=(select Isnull(max(Item_IA),0)+1 from Volume_Imp_Aer where Num_Proc_HIA=@Num_Proc_HIA )
			SET @Item_IA = '0'+@Item_IA
			SET @Item_IA = right(@Item_IA,2)
			INSERT INTO
				Volume_Imp_Aer
				(
					Num_Proc_HIA,
					Item_IA,
					Qtd_Vol_IA,
					Cd_Tp_Embal,
					Compr_IA,
					Largura_IA,
					Altura_IA,
					Peso_Bruto_IA,
					Id_NCM,
					Marca_IA,
					Contra_Marca,
					Vol_Item_IA,
					cd_tp_unidade
				)
			VALUES
				(
					@Num_Proc_HIA,
					@Item_IA,
					@Qtd_Vol_IA,
					@Cd_Tp_Embal,
					@Compr_IA,
					@Largura_IA,
					@Altura_IA,
					@Peso_Bruto_IA,
					@Id_NCM,
					@Marca_IA,
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
