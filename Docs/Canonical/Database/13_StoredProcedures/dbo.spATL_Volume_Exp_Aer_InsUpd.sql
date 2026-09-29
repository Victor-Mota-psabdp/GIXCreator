SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Volume_Exp_Aer_InsUpd]
(
	@Num_Proc	  varchar(16),
	@Item 	      varchar(2),
	@Qtd_Vol	  Float, 
	@Embalagem	  varchar(30),
	@Comprimento  Float,
	@Largura	  Float,
	@Altura	      Float,
	@Peso_Bruto	  Float,
	@NCM		  varchar(12),
	@Marca	      varchar(2000),
	@Contra_Marca varchar(2000),
	@Volume		  Float
)

AS

BEGIN TRANSACTION

Declare @cd_tp_embal 	varchar(3)
Declare @Id_NCM			int


 
set @cd_tp_embal = (select cd_tp_embal from tipo_embalagem where nome_tp_embal = @Embalagem)
set @Id_NCM = (select id_ncm from NCM where ncm = @NCM)
	if exists (select Item_EA from Volume_Exp_Aer where Item_EA = @Item and Num_Proc_HEA = @Num_Proc)
		BEGIN
			UPDATE
				Volume_Exp_Aer
			SET
				Qtd_Vol_EA	   =@Qtd_Vol,
				Cd_Tp_Embal    =@Cd_Tp_Embal,
				Compr_EA	   =@Comprimento,
				Largura_EA	   =@Largura,
				Altura_EA	   =@Altura,
				Peso_Bruto_EA  =@Peso_Bruto,
				Id_NCM	  	   =@Id_NCM,
				Marca_EA	   =@Marca,
				Contra_Marca   =@Contra_Marca,
				Vol_Item_EA	   =@Volume,
				cd_tp_unidade  ='M3'
			WHERE
				Item_EA = @Item and Num_Proc_HEA = @Num_Proc
		END
	ELSE
		BEGIN
			SET @Item=(select Isnull(max(Item_EA),0)+1 from Volume_Exp_Aer where Num_Proc_HEA=@Num_Proc)
			SET @Item = '0'+@Item
			SET @Item = right(@Item,2)
			INSERT INTO
				Volume_Exp_Aer
				(
					Num_Proc_HEA,
					Item_EA,
					Qtd_Vol_EA,
					Cd_Tp_Embal,
					Compr_EA,
					Largura_EA,
					Altura_EA,
					Peso_Bruto_EA,
					Id_NCM,
					Marca_EA,
					Contra_Marca,
					Vol_Item_EA,
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
