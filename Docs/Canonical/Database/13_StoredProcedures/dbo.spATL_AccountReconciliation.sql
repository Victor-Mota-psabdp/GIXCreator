SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu produção 10/12/2020 - 10:24h
--/*-----------------------------------------------------------------
---
--HISTORY CHANGE
--- Date: 16/11/2020
--- Business: Márcia Silvia (Marcia.Silva@bdpint.com)
--- Dept.:Operations
--- Developer: Jorge Gatica
--- Ticket: 100-208981
--- Request: Inclusions of columns to Speco Group
---------------------------------------------------------------------
--EXECUTION
----[spATL_AccountReconciliation] 'Grupo Speco','2012-05-01','2012-05-31'
----   100-208981 -JACG-16/11/2020
---------------------------------------------------------------------
--*/

--ALTER Procedure [dbo].[spATL_AccountReconciliation]
--	@Grupo varchar(20),
--	@DtInicial datetime,
--	@DtFinal datetime
--as
	
--if @Grupo = 'GRUPO DOW'
--	begin
--		exec [dbo].[spATL_AccountReconciliation_V2_Rel] @Grupo, @DtInicial,@DtFinal
--	end
--else
--     if @Grupo = 'GRUPO SPECO'
--	begin
-----------------Inclusão JACG 16/11/2020--------------
--		exec [dbo].[spATL_BDP_AccountReconciliation_V3_Rel] @Grupo, @DtInicial,@DtFinal 
--	end
--     else
--	begin
--		exec [dbo].[spATL_BDP_AccountReconciliation_Rel] @Grupo, @DtInicial,@DtFinal 
--	end


CREATE Procedure [dbo].[spATL_AccountReconciliation]
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
as
	
if @Grupo = 'GRUPO DOW'
	BEGIN
		exec [dbo].[spATL_AccountReconciliation_V2_Rel] @Grupo, @DtInicial,@DtFinal

	end
Else
	Begin
		if @Grupo = 'GRUPO SPECO'
		begin
---------------Inclusão JACG 16/11/2020--------------
			exec [dbo].[spATL_BDP_AccountReconciliation_V3_Rel] @Grupo, @DtInicial,@DtFinal 
		end
	else
		Begin
			if @Grupo = 'GRUPO CORTEVA'
				begin
---------------Added by AO - 2021-08-13--------------
					exec [dbo].[spATL_BDP_AccountReconciliationCorteva_Rel]  @Grupo, @DtInicial,@DtFinal 
				end
			else
				BEGIN
					exec [dbo].[spATL_BDP_AccountReconciliation_Rel] @Grupo, @DtInicial,@DtFinal 
				END
		End 
	End

GO
