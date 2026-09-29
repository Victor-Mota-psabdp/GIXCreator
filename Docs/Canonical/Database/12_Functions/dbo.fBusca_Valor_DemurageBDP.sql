SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  function [dbo].[fBusca_Valor_DemurageBDP](
	@cd_tp_cont as varchar(3),
	@dias as int	
)returns Float
AS

BEGIN

	--Declare @cd_tp_cont as varchar(3)
	--Declare @dias as int
	Declare @dias1 as int
	Declare @dias2 as int
	Declare @dias3 as int
		
	Declare @Valor1 as float
	Declare @Valor2 as float
	Declare @Valor3 as float
	
		
	set @Valor1 = 0
	set @Valor2	= 0
	set @Valor3	= 0
				
	--set @cd_tp_cont = (select Cd_Tp_Cont from Container_Mas_Imp_Mar 
	--	where Num_Proc_MIM = 'IMSAP201412001' and Item_Cont_IM = 2)		
			
	set @dias1 = (select dias from Taxa_Demurrage_BDP TDE where cd_tp_cont =@cd_tp_cont and Periodo = 1)
	set @dias2 = (select dias from Taxa_Demurrage_BDP TDE where cd_tp_cont =@cd_tp_cont and Periodo = 2)
	set @dias3 = (select dias from Taxa_Demurrage_BDP TDE where cd_tp_cont =@cd_tp_cont and Periodo = 3)	
				
	if @dias <= @dias1
		begin		
			set @Valor1 = (select Taxa * @dias from Taxa_Demurrage_BDP TDE 
					where cd_tp_cont =@cd_tp_cont and Periodo = 1)
		end
	else if @dias > @dias1 and @dias <= @dias1 + @dias2
		begin
			set @Valor1 = (select Taxa * @dias1 from Taxa_Demurrage_BDP TDE 
					where cd_tp_cont =@cd_tp_cont and Periodo = 1)
			set @dias = @dias - @dias1
			set @Valor2 = (select Taxa * @dias from Taxa_Demurrage_BDP TDE 
					where cd_tp_cont =@cd_tp_cont and Periodo = 2)			
		end
			
	else if @dias > @dias1 + @dias2
		Begin			
			set @Valor1 = (select Taxa * @dias1 from Taxa_Demurrage_BDP TDE 
					where cd_tp_cont =@cd_tp_cont and Periodo = 1)
			set @dias = @dias - @dias1
			set @Valor2 = (select Taxa * @dias2 from Taxa_Demurrage_BDP TDE 
					where cd_tp_cont =@cd_tp_cont and Periodo = 2)
			set @dias = @dias - @dias2
			set @Valor3 = (select Taxa * @dias from Taxa_Demurrage_BDP TDE 
					where cd_tp_cont =@cd_tp_cont and Periodo = 3)
		End		
	
	
	return @Valor1 + @Valor2 + @Valor3
	
END






GO
