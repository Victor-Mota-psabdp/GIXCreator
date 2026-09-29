SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--update PO_HIM set Data_PO_HIM = GETDATE()
--where Num_Proc_HIM = 'IMCSR201802485BR' and ID_DC = 5

--delete Campo_Processo 
--where Id_Campo = '172' and Num_Proc = 'IMCSR201802487BR'
--select * from  Campo_Processo 
--where Id_Campo = '172' and Num_Proc = 'IMCSR201802487BR'
--IMCSR201802485BR
--IMCSR201802487BR
--select * from Paridade
--insert Paridade
--select '25/04/2018','USD','XXX',3
--176	10017	F	Paridade Dolar D.I.

CREATE procedure [dbo].[spATL_AtualizaParidadeSiscomex_InsUpd]
as

Declare @ParDI varchar(30)
Declare @Temp1 varchar(500)
Declare @MSG varchar(500)
Declare @Num_Proc varchar(16)
Declare @Data_PO datetime
Declare @DataHoje datetime

set @DataHoje = (select GETDATE())	
		Declare C_JOBs cursor for
			select Num_Proc_HIM Num_Proc, Data_PO_HIM Data_PO from PO_HIM PO with(nolock)
			left join Campo_Processo CP with(nolock) on PO.Num_Proc_HIM = CP.Num_Proc and CP.Id_Campo = '176'
			where ID_DC = 5 and Data_PO_HIM >=  GETDATE()-30
			 and (CP.Campo_Dados = '' or CP.Campo_Dados is null)
			union all
			select Num_Proc_HIA Num_Proc, Data_PO_HIA Data_PO from PO_HIA PO with(nolock)
			left join Campo_Processo CP with(nolock) on PO.Num_Proc_HIA = CP.Num_Proc and CP.Id_Campo = '176'
			where ID_DC = 5 and Data_PO_HIA >= GETDATE()-30
			 and (CP.Campo_Dados = '' or CP.Campo_Dados is null)
			union all
			select Num_Proc_HIO Num_Proc, Data_PO_HIO Data_PO from PO_HIO PO with(nolock)
			left join Campo_Processo CP with(nolock) on PO.Num_Proc_HIO = CP.Num_Proc and CP.Id_Campo = '176'
			where ID_DC = 5 and Data_PO_HIO >=  GETDATE()-30
			and (CP.Campo_Dados = '' or CP.Campo_Dados is null)
		Open C_JOBs 
		SET NOCOUNT ON
		Fetch Next From C_JOBS Into @Num_Proc, @Data_PO
			While @@FETCH_STATUS = 0
				Begin
					set @ParDI =(Select Par_Moeda From Paridade with(nolock) Where  convert(datetime,Dt_Par,103) =convert(varchar,@Data_PO,111) and Cd_Tp_Par = 'XXX' and Cd_Tp_Moeda = 'USD')
					if @ParDI is not null
						Begin	
							set @ParDI = CAST(REPLACE(cast(@ParDI as float),'.',',')AS VARCHAR(30))
							EXEC spATL_CamposAdicionais_InsUpd @Num_Proc, 'Paridade Dolar D.I.',@ParDI, 'ATL'
							Set @MSG=(@Num_Proc + ' - Paridade Dolar D.I. : ' + @ParDI + ' Data: ' + convert(varchar(10),@Data_PO,103))
							print @MSG
							exec dbo.[spHistG_InsUPD] @Num_Proc,Null ,Null,'CSR',@MSG,@DataHoje,null ,'ATL System','N','U',null 
						End
				Fetch Next From C_JOBS Into @Num_Proc, @Data_PO
				END
		close C_JOBS
		deallocate C_JOBS	
		
/*
Declare @ParHoje varchar(30)
Declare @Temp1 varchar(500)
Declare @MSG varchar(500)
Declare @Num_Proc varchar(16)
Declare @DataHoje datetime
set @DataHoje = (select GETDATE())	
set @ParHoje = (Select Par_Moeda From Paridade Where  convert(datetime,Dt_Par,103) =convert(varchar,getdate(),111) and Cd_Tp_Par = 'XXX' and Cd_Tp_Moeda = 'USD')
print @ParHoje
print convert(varchar(10),GETDATE(),105)
if @ParHoje is not null
	Begin
	set @ParHoje = CAST(REPLACE(cast(@ParHoje as float),'.',',')AS VARCHAR(30))
	print @ParHoje
		Declare C_JOBs cursor for
			select Num_Proc_HIM Num_Proc from PO_HIM PO with(nolock)
			left join Campo_Processo CP with(nolock) on PO.Num_Proc_HIM = CP.Num_Proc and CP.Id_Campo = '176'
			where ID_DC = 5 and convert(varchar(10),Data_PO_HIM,103) =  convert(varchar(10),GETDATE(),103) 
			 and (CP.Campo_Dados = '' or CP.Campo_Dados is null)
			union all
			select Num_Proc_HIA Num_Proc from PO_HIA PO with(nolock)
			left join Campo_Processo CP with(nolock) on PO.Num_Proc_HIA = CP.Num_Proc and CP.Id_Campo = '176'
			where ID_DC = 5 and convert(varchar(10),Data_PO_HIA,103) =  convert(varchar(10),GETDATE(),103) 
			 and (CP.Campo_Dados = '' or CP.Campo_Dados is null)
			union all
			select Num_Proc_HIO Num_Proc from PO_HIO PO with(nolock)
			left join Campo_Processo CP with(nolock) on PO.Num_Proc_HIO = CP.Num_Proc and CP.Id_Campo = '176'
			where ID_DC = 5 and convert(varchar(10),Data_PO_HIO,103) =  convert(varchar(10),GETDATE(),103)  
			and (CP.Campo_Dados = '' or CP.Campo_Dados is null)
		Open C_JOBs 
		SET NOCOUNT ON
		Fetch Next From C_JOBS Into @Num_Proc
			While @@FETCH_STATUS = 0
				Begin
					EXEC spATL_CamposAdicionais_InsUpd @Num_Proc, 'Paridade Dolar D.I.',@ParHoje, 'ATL'
					Set @MSG=('Paridade Dolar D.I. : ' + @ParHoje + ' Data: ' + convert(varchar(10),GETDATE(),103))
					exec dbo.[spHistG_InsUPD] @Num_Proc,Null ,Null,'CSR',@MSG,@DataHoje,null ,'ATL System','N','U',null 
					Fetch Next From C_JOBS Into @Num_Proc
				END
		close C_JOBS
		deallocate C_JOBS
		End		
		
*/
GO
