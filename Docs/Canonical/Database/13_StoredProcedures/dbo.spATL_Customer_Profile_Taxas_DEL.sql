SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----SP_HELP Customer_Profile_Taxas
--[spATL_Customer_Profile_Taxas_DEL] '10','LBD','','J','J','',''
--SELECT ID_CP, cd_tp_tx FROM Customer_Profile_taxas WHERE
--ID_CP = 10 and Cd_tp_tx = 'LBD' 
--and (cd_fornecedor = '' or cd_fornecedor is null) 
-- and cd_tipo_compra = 'J' 
--and cd_tipo_venda = 'J' 

CREATE procedure [dbo].[spATL_Customer_Profile_Taxas_DEL]
	
	@ID_CP				int,
	@Cd_Tp_Tx			varchar(3),
	@Cd_Fornecedor		varchar(10),
	@Cd_Tipo_Compra		varchar(1),	
	@Cd_Tipo_Venda		varchar(1),
	@Cd_Range_Compra	char(1),	
	@Cd_Range_Venda		char(1)

AS

Begin Transaction
		
		IF exists(SELECT ID_CP, cd_tp_tx FROM Customer_Profile_taxas WHERE ID_CP = @ID_CP and Cd_tp_tx = @Cd_tp_tx 
						and (cd_fornecedor = @cd_fornecedor or cd_fornecedor is null) and cd_tipo_compra = @Cd_Tipo_Compra 
						and cd_tipo_venda = @cd_tipo_venda and 
						(
							(Cd_Range_Venda = @Cd_Range_Venda and Cd_Range_Compra = @Cd_Range_Compra)
							or		
							(Cd_Range_Venda is null and Cd_Range_Compra = @Cd_Range_Compra)	
							or 
							(Cd_Range_Venda =@Cd_Range_Venda  and Cd_Range_Compra  is null)
							or
							(Cd_Range_Venda  is null  and Cd_Range_Compra  is null)
						)
					)
				BEGIN
					DELETE
						Customer_profile_taxas				
					WHERE
						ID_CP = @ID_CP 
						and Cd_tp_tx = @Cd_tp_tx 
						and (cd_fornecedor = @cd_fornecedor or cd_fornecedor is null) 
						 and cd_tipo_compra = @Cd_Tipo_Compra 
						and cd_tipo_venda = @cd_tipo_venda 
						and (
							(Cd_Range_Venda = @Cd_Range_Venda and Cd_Range_Compra = @Cd_Range_Compra)
							or		
							(Cd_Range_Venda is null and Cd_Range_Compra = @Cd_Range_Compra)	
							or 
							(Cd_Range_Venda =@Cd_Range_Venda  and Cd_Range_Compra  is null)
							or
							(Cd_Range_Venda  is null  and Cd_Range_Compra  is null)
						)										
				
		END
	
	
--IF @@Error <> 0
--		BEGIN
--			PRINT 'ERRADO'
--			ROLLBACK TRANSACTION
--			rETURN -1
--		END
Commit Transaction


/*

	if (ISNULL(@Cd_Range_Compra,'') = '' and ISNULL(@Cd_Range_Venda,'') = '')
		BEGIN		
		IF exists(SELECT ID_CP, cd_tp_tx FROM Customer_Profile_taxas WHERE ID_CP = @ID_CP and Cd_tp_tx = @Cd_tp_tx 
			and (Cd_Fornecedor = @Cd_Fornecedor or Cd_Fornecedor is null) and Cd_Tipo_Compra = @Cd_Tipo_Compra 
			and Cd_Tipo_Venda = @Cd_Tipo_Venda and Cd_Range_Venda is null and Cd_Range_Compra is null)
				BEGIN
					DELETE
						Customer_profile_taxas				
					WHERE
						ID_CP = @ID_CP 
						and Cd_tp_tx = @Cd_tp_tx 
						and (cd_fornecedor = @cd_fornecedor or cd_fornecedor is null) 
						 and cd_tipo_compra = @Cd_Tipo_Compra 
						and cd_tipo_venda = @cd_tipo_venda 
						and Cd_Range_Venda is null 
						and Cd_Range_Compra is null
												
				END
		END
	
	if (@Cd_Range_Compra <> ''  and ISNULL(@Cd_Range_Venda,'') = '')
		BEGIN	
		IF exists(SELECT ID_CP, cd_tp_tx FROM Customer_Profile_taxas WHERE	ID_CP = @ID_CP and Cd_tp_tx = @Cd_tp_tx 
			and (cd_fornecedor = @cd_fornecedor or cd_fornecedor is null) and cd_tipo_compra = @Cd_Tipo_Compra 
			and cd_tipo_venda = @cd_tipo_venda and Cd_Range_Venda is null and Cd_Range_Compra=@Cd_Range_Compra)
				BEGIN
					DELETE
						Customer_profile_taxas				
					WHERE
						ID_CP = @ID_CP 
						and Cd_tp_tx = @Cd_tp_tx 
						and (cd_fornecedor = @cd_fornecedor or cd_fornecedor is null) 
						 and cd_tipo_compra = @Cd_Tipo_Compra 
						and cd_tipo_venda = @cd_tipo_venda 
						and Cd_Range_Venda is null 
						and Cd_Range_Compra =@Cd_Range_Compra
												
				END
		END
		
	if (ISNULL(@Cd_Range_Compra,'') = '' and @Cd_Range_Venda <> '')
		BEGIN			
		IF exists(SELECT ID_CP, cd_tp_tx FROM Customer_Profile_taxas WHERE ID_CP = @ID_CP and Cd_tp_tx = @Cd_tp_tx 
			and (cd_fornecedor = @cd_fornecedor or cd_fornecedor is null) and cd_tipo_compra = @Cd_Tipo_Compra 
			and cd_tipo_venda = @cd_tipo_venda and Cd_Range_Venda=@Cd_Range_Venda and Cd_Range_Compra is null)
				BEGIN
					DELETE
						Customer_profile_taxas				
					WHERE
						ID_CP = @ID_CP 
						and Cd_tp_tx = @Cd_tp_tx 
						and (cd_fornecedor = @cd_fornecedor or cd_fornecedor is null) 
						 and cd_tipo_compra = @Cd_Tipo_Compra 
						and cd_tipo_venda = @cd_tipo_venda 
						and Cd_Range_Venda =@Cd_Range_Venda
						and Cd_Range_Compra is null 
												
				END
		END
		
	if (@Cd_Range_Compra   <> ''  and @Cd_Range_Venda <> '')
		BEGIN		
		IF exists(SELECT ID_CP, cd_tp_tx FROM Customer_Profile_taxas WHERE
			ID_CP = @ID_CP and Cd_tp_tx = @Cd_tp_tx 
			and (cd_fornecedor = @cd_fornecedor or cd_fornecedor is null) 
			 and cd_tipo_compra = @Cd_Tipo_Compra 
			and cd_tipo_venda = @cd_tipo_venda and Cd_Range_Venda =@Cd_Range_Venda
						and Cd_Range_Compra =@Cd_Range_Compra)
				BEGIN
					DELETE
						Customer_profile_taxas				
					WHERE
						ID_CP = @ID_CP 
						and Cd_tp_tx = @Cd_tp_tx 
						and (cd_fornecedor = @cd_fornecedor or cd_fornecedor is null) 
						 and cd_tipo_compra = @Cd_Tipo_Compra 
						and cd_tipo_venda = @cd_tipo_venda 
						and Cd_Range_Venda =@Cd_Range_Venda
						and Cd_Range_Compra =@Cd_Range_Compra
												
				END
		END
		*/

GO
