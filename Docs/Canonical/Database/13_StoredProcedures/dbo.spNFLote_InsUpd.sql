SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE         Procedure [dbo].[spNFLote_InsUpd] --'55732','15068408','748CVMOM01',1534

	@Num_NF			varchar(50),
	@Cd_Fornecedor	varchar(10),
	@Lote			varchar(30),
	@Cd_Pedido		int

as
BEGIN TRANSACTION
		Declare @Cd_Pes Varchar(10)

		Set @Cd_Pes=(select top 1 cd_pes from Pessoa_llp where cd_vendor=@cd_fornecedor)
		if not exists(select num_nf from nota_fiscal_lote where lote=@lote and num_nf=@num_nf and cd_fornecedor=@cd_pes)
			BEGIN
				INSERT INTO
					Nota_Fiscal_Lote
					(
						Num_NF,
						Cd_Fornecedor,
						Lote,
						Cd_Pedido	
					)			
				VALUES
					(
						@Num_NF,
						@Cd_Pes,
						@Lote,
						@Cd_Pedido	
					)			
		IF @@ERROR <> 0 
		BEGIN 
			ROLLBACK TRANSACTION
			RETURN -1
		END

			END

COMMIT TRANSACTION




GO
