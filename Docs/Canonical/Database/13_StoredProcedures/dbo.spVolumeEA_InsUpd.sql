SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spVolumeEA_InsUpd]'EAATL202206001BR','01',4,'Pallet(s)','1.20','1.00','0.76','900.000','39061000','','','1.00',Null

CREATE procedure [dbo].[spVolumeEA_InsUpd]
(
	@Num_Proc_HEA	varchar(16),
	@Item_EA 	varchar(2),
	@Qtd_Vol_EA	Float, 
	@Embalagem	varchar(30),
	@Compr_EA	Float,
	@Largura_EA	Float,
	@Altura_EA	Float,
	@Peso_Bruto_EA	Float,
	@NCM		varchar(8),
	@Marca_EA	varchar(2000),
	@Contra_Marca	varchar(2000),
	@Volume		Float,
	--Alterado Por Erbson 31-08-2012 - Remover Handling
	--Alterado Por Erbson 17-09-2012 - Retorno Handling
	@Handling	varchar(200)
)

AS

BEGIN TRANSACTION

Declare @cd_tp_embal 	varchar(3)
Declare @Id_NCM			int


 
set @cd_tp_embal = (select cd_tp_embal from tipo_embalagem where nome_tp_embal = @Embalagem)
set @Id_NCM = (select id_ncm from NCM where ncm = @NCM)
	if exists (select Item_EA from Volume_Exp_Aer where Item_EA = @Item_EA and Num_Proc_HEA = @Num_Proc_HEA)
		BEGIN
			UPDATE
				Volume_Exp_Aer
			SET
				Qtd_Vol_EA	=@Qtd_Vol_EA,
				Cd_Tp_Embal	=@Cd_Tp_Embal,
				Compr_EA	=@Compr_EA,
				Largura_EA	=@Largura_EA,
				Altura_EA	=@Altura_EA,
				Peso_Bruto_EA	=@Peso_Bruto_EA,
				Id_NCM		=@Id_NCM,
				Marca_EA	=@Marca_EA,
				Contra_Marca	=@Contra_Marca,
				Vol_Item_EA	=@Volume,
				cd_tp_unidade	='M3'
			WHERE
				Item_EA = @Item_EA and Num_Proc_HEA = @Num_Proc_HEA
		END
	ELSE
		BEGIN
			SET @Item_EA=(select Isnull(max(Item_EA),0)+1 from Volume_Exp_Aer where Num_Proc_HEA=@Num_Proc_HEA )
			SET @Item_EA = '0'+@Item_EA
			SET @Item_EA = right(@Item_EA,2)
			INSERT INTO
				Volume_Exp_Aer
				(
					Num_Proc_HEA,Item_EA,Qtd_Vol_EA,Cd_Tp_Embal,Compr_EA,Largura_EA,Altura_EA,Peso_Bruto_EA,Id_NCM,Marca_EA,Contra_Marca,Vol_Item_EA,cd_tp_unidade
				)
			VALUES
				(
					@Num_Proc_HEA,@Item_EA,@Qtd_Vol_EA,@Cd_Tp_Embal,@Compr_EA,@Largura_EA,@Altura_EA,@Peso_Bruto_EA,@Id_NCM,@Marca_EA,@Contra_Marca,@Volume,'M3'
				)
		END

	

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRANSACTION






GO
