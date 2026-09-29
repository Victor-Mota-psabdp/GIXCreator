SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spCustomerCliente_Del] 
	@ID_CP int
as

--	Declare @cd_cliente		varchar(10)
--	Declare @cd_org			varchar(3)
--	Declare @cd_dst			varchar(3)	
--
--	set @cd_cliente = (select cd_pes from pessoa where apelido = @cliente)
--	
--	if @org <> ''
--		set @cd_org = (select cd_local from localidade where nome_local=@org)
--	else
--		set @cd_org = 'ALL'	
--	
--	if @dst <> ''
--		set @cd_dst = (select cd_local from localidade where nome_local=@dst)
--	else
--		set @cd_dst = 'ALL'

	delete customer_profile_taxas where id_cp = @Id_Cp
             
	delete customer_profile where id_cp = @Id_Cp
	
	IF @@Error <> 0
		BEGIN
			PRINT 'ERRADO'
			ROLLBACK TRANSACTION
			rETURN -1
		END
Commit Transaction




GO
