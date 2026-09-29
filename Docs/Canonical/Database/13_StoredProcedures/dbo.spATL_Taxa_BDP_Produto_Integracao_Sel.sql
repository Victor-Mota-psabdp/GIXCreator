SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Taxa_BDP_Produto_Integracao_Sel]--'I0AET201502005BR'
(
	@num_proc as varchar(16),
	@Nome_tp_tx as varchar(50)
	
)
as

declare @ID_PD int

set @ID_PD  = (select Campo_Dados from Campo_Processo where Id_Campo = 143 and Num_Proc = @num_proc)

if @ID_PD = 3

	select 
		nome_tp_tx,tipo_prod_code 	
	from 
		tipo_Taxa TT with(nolock)
	join  dbo.Tipo_Taxa_Modal TM with(nolock) on TT.Cd_Tp_Tx = TM.Cd_Tp_Tx
	join vwClienteALLJOBS CL with(nolock) on CL.num_proc = @num_proc
		where  
			Nome_Tp_Tx = @Nome_tp_tx and
			Desat_Tx='N'
			--and (ND_tx = substring(@num_proc,2,1) or ND_tx = 'T')
			and (TM.Cd_TP_Modal = substring(@num_proc,1,2) or TM.Cd_TP_Modal = 'AL')
			and (CL.Cd_Tp_Oper = TM.Cd_Tp_Oper or TM.Cd_Tp_Oper = 'BDP')
			and tipo_prod_code is not null
			--and Nome_Tp_Tx  not like 'Prestacao%'	
			and TT.cd_tp_tx not in ('XCA','XCQ','XEQ','XEU','XFS','XFU','XFV','XGA','XGB','XZD')		
	order by nome_tp_tx

else if @ID_PD = 1 or @ID_PD = 2
	select 
		nome_tp_tx ,tipo_prod_code
	from 
		tipo_Taxa TT with(nolock)
	join  dbo.Tipo_Taxa_Modal TM with(nolock) on TT.Cd_Tp_Tx = TM.Cd_Tp_Tx
	join vwClienteALLJOBS CL with(nolock) on CL.num_proc = @num_proc
	where 
		Nome_Tp_Tx = @Nome_tp_tx and
		Desat_Tx='N' 
		--and (ND_tx = substring(@num_proc,2,1) or ND_tx = 'T') 
		and (TM.Cd_TP_Modal = substring(@num_proc,1,2) or TM.Cd_TP_Modal = 'AL')
		and (CL.Cd_Tp_Oper = TM.Cd_Tp_Oper or TM.Cd_Tp_Oper = 'BDP')
		and (tipo_prod_code = @ID_PD or tipo_prod_code = 3)
		--and Nome_Tp_Tx  not like 'Prestacao%'
		and TT.cd_tp_tx not in ('XCA','XCQ','XEQ','XEU','XFS','XFU','XFV','XGA','XGB','XZD')	
	order by nome_tp_tx
	

--declare @ID_PD int

--set @ID_PD  = (select Campo_Dados from Campo_Processo where Id_Campo = 143 and Num_Proc = @num_proc)

--if @ID_PD = 3

--	select nome_tp_tx,tipo_prod_code from tipo_Taxa 
--		where 
--			Nome_Tp_Tx = @Nome_tp_tx and
--			Desat_Tx='N'
--			and (ND_tx = substring(@num_proc,2,1) or ND_tx = 'T')
--			and tipo_prod_code is not null
--			--and Nome_Tp_Tx  not like 'Prestacao%'	
--			and cd_tp_tx not in ('XCA','XCQ','XEQ','XEU','XFS','XFU','XFV','XGA','XGB','XZD')		
--	order by nome_tp_tx

--else if @ID_PD = 1 or @ID_PD = 2
--	select 
--		nome_tp_tx ,tipo_prod_code
--	from 
--		tipo_Taxa 
--	where 
--		Nome_Tp_Tx = @Nome_tp_tx and
--		Desat_Tx='N' 
--		and (ND_tx = substring(@num_proc,2,1) or ND_tx = 'T') 
--		and (tipo_prod_code = @ID_PD or tipo_prod_code = 3)
--		--and Nome_Tp_Tx  not like 'Prestacao%'
--		and cd_tp_tx not in ('XCA','XCQ','XEQ','XEU','XFS','XFU','XFV','XGA','XGB','XZD')	
--	order by nome_tp_tx
	

GO
