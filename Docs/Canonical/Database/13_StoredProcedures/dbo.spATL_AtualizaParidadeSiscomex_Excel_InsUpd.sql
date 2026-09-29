SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spATL_AtualizaParidadeSiscomex_Excel_InsUpd] 'IMCSR201712574BR','2018-01-02 00:00:00.000'
CREATE procedure [dbo].[spATL_AtualizaParidadeSiscomex_Excel_InsUpd]
(
	@num_proc as varchar(16),
	@data as datetime
)
as

Declare @Paridade varchar(30)
Declare @Temp1 varchar(500)
declare @DataHoje as datetime
set @DataHoje = (select GETDATE())	

Declare @MSG varchar(500)
set @Paridade = (Select Par_Moeda From Paridade Where 
			convert(datetime,Dt_Par,103) =convert(varchar,@data,111) 
			and Cd_Tp_Par = 'XXX' and Cd_Tp_Moeda = 'USD')
			
print @Paridade

print convert(varchar(10),GETDATE(),105)
if @Paridade is not null
	Begin
	set @Paridade = CAST(REPLACE(cast(@Paridade as float),'.',',')AS VARCHAR(30))
	print @Paridade		
				Begin
					EXEC spATL_CamposAdicionais_InsUpd @Num_Proc, 'Paridade Dolar D.I.',@Paridade, 'ATL'
					
					Set @MSG=('Paridade Dolar D.I. : ' + @Paridade + ' Data: ' + convert(varchar(10),GETDATE(),103))
					exec dbo.[spHistG_InsUPD] @Num_Proc,Null ,Null,'CSR',@MSG,@DataHoje,null ,'ATL System','N','U',null 
				END

		End		
GO
