SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_Tarefas_Processos_Alerta_Sel 'A'
Create procedure [dbo].[spATL_Tarefas_Processos_Alerta_JuntaPDF_Sel] 
(	
	--@Num_Proc			varchar(16),
	--@ID_Task			int,
	--@cd_pes_grupo		varchar(10),
	--@ID_Alerta			bigint,
	@Tipo				char(1)
)
as
	
/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codgo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
S e L para Solicitacao de LI
*/

--sp_help Tarefas_Processos_Alerta
IF @Tipo = 'A' or @Tipo = 'B' or @Tipo = 'C' or @Tipo = 'D' or @Tipo = 'N' OR @Tipo = 'O'
	Begin
		select distinct		
			A.ID_Alerta										[Code],
			TP.Num_Proc										[JOB],
			--isnull(TP.Cd_Usuario,LLP.Cd_Usuario)			[User Code],
			--isnull(US.Nome_Usuario,CUST.Nome_Usuario)		[User Name],
			LLP.Cd_Usuario									[User Code],
			CUST.Nome_Usuario								[User Name],
			TP.Dt_Insert									[Insert Date],
			TPA.Dt_Envio									[Sent Date],
			
			TP.ID_Task										[Task Type Code],			
			TP.Dt_Previsao									[Prevision Date],		
			TP.Dt_Insert									[Insert Date],
			TP.ID_TP										[ID_TP]

		from Tarefas_Processos			TP with(nolock)			
			join Alerta_Email_Doc_Automatico	A with(nolock) on A.ID_Task = TP.ID_Task and A.Modal = LEFT(TP.Num_Proc,2) --and A.ID_Alerta = TP.ID_Alerta
			left join Tarefas_Processos_Alerta	TPA	with (nolock) on TP.Num_proc=TPA.Num_proc and A.ID_Alerta = TPA.ID_Alerta --and TP.Id_task =TPA.Id_task
			--left Join Usuario					US	with (nolock) on TP.cd_usuario=US.cd_usuario
			Join vwCliente_Alerta				LLP	with (nolock)on TP.Num_Proc = LLP.num_proc	
			join Pessoa_LLP						PLL with (nolock) on PLL.Cd_Pes=LLP.cd_cliente	
			Join Usuario						CUST with (nolock) on CUST.cd_usuario=LLP.cd_usuario	
			left Join Localidade				Org	with (nolock) on Org.cd_local=LLP.Cd_Org
			left Join Localidade				Dst	with (nolock) on DST.cd_local=LLP.Cd_Dst	
			left Join Pedido_Ship				PS	with(nolock) on PS.num_proc=TP.Num_Proc
			left Join Pedido					P	with(nolock) on P.cd_pedido=PS.cd_pedido	
			left join Pessoa					CLI with(nolock) on CLI.Cd_Pes = LLP.cd_cliente_master	
		
			left Join PROC_NCM					PROCNCM	with(nolock) on PROCNCM.num_proc=TP.Num_Proc
			left Join NCM						NCM	with(nolock) on PROCNCM.ID_NCM=NCM.ID_NCM
			
			left join Campo_Processo			CP5	with (nolock) on TP.Num_proc=CP5.Num_proc and CP5.Id_Campo = 5
			left Join Verdade					VD	with(nolock) on convert(Varchar(1),VD.Id) =CP5.Campo_Dados

			left Join vwATL_Container			CONT	with(nolock) on CONT.num_proc=TP.Num_Proc

			left join Campo_Processo			CP143	with (nolock) on TP.Num_proc=CP143.Num_proc and CP143.Id_Campo = 143 --Leandro BDP Produto
			left join Campo_Processo			CP86	with (nolock) on TP.Num_proc=CP86.Num_proc and CP86.Id_Campo = 86 --Leandro Operador de Tank
			left join Campo_Processo			CP185	with (nolock) on TP.Num_proc=CP185.Num_proc and CP185.Id_Campo = 185 --Leandro Operador de Tank
			left join Usuario_Cliente			UC		with(nolock) on  UC.Cd_Usuario = A.Cd_Usuario_Cliente --Leandro Operador de Tank
			

		Where
			--TP.Num_proc = 'IMEXO202502088BR' and --comentar esta linha quando terminar os testes 26/12/23 //Comentado por Leandro
			--A.ID_Alerta = 3439 and
			TP.Dt_Insert > (GETDATE() - A.Dias)	
			and	A.Ativo = 1				
			and TP.Dt_Conclusao is not null
			and TPA.dt_envio is null	

			and (
					(isnull(A.cd_tp_carga,0) = 0  and LLp.Cd_Tp_Carga >= 0)
					or 
					(A.cd_tp_carga = LLp.Cd_Tp_Carga)					
				)
	
			and (
					(A.Cd_Org = LLP.cd_org and A.Cd_Dst = LLP.Cd_Dst)
					or		
					(isnull(A.Cd_Org,'ALL') = 'ALL'  and isnull(A.Cd_Dst,'ALL') = 'ALL')		
					or 
					(isnull(A.Cd_Org,'ALL') = 'ALL' and A.Cd_Dst = LLP.Cd_Dst)
					or
					(isnull(A.Cd_Dst,'ALL')= 'ALL' and  A.Cd_Org = LLP.cd_org)
				)
		
			and (
					(isnull(A.cd_tp_pedido,'1') = '1' and '0' not in ('2','3','4'))
					or 
					(A.cd_tp_pedido = P.Cd_tipo)
				)
	
			and (
					(isnull(A.cd_pes,'ALL') = 'ALL' and LLP.cd_cliente <> 'ALL')
					or 
					(A.cd_pes = LLP.cd_cliente)
				)
	
			And (
					(A.Email_do_Agente_Consolidado = 1 and LLP.Master <> 'JOB') 
					or
					(A.Email_do_Agente_Consolidado = 0 and LLP.Master is not null)
				)
	
			and (
					(isnull(A.Cd_Transportadora,'ALL') = 'ALL' and isnull(LLP.Cd_Transportadora,'') <> 'ALL')
					or 
					(A.Cd_Transportadora = LLP.Cd_Transportadora)
				)
	
			and (
					(isnull(A.cd_pes_grupo,'ALL') = 'ALL' and PLL.cd_pes_grupo <> 'ALL')
					or 
					(A.Cd_Pes_Grupo = PLL.cd_pes_grupo)
				)
		
			and (
					(isnull(A.Cd_Terminal,'ALL')  = 'ALL' and isnull(LLP.Cd_Terminal,'') <> 'ALL')
					or 
					(A.Cd_Terminal = LLP.Cd_Terminal)
				)

			and (
					(isnull(A.Cd_Pes_Out,'ALL') = 'ALL' and isnull(LLP.Cd_Fornecedor,'') <> 'ALL')
					or 
					(A.Cd_Pes_Out = LLP.Cd_Fornecedor)
				)

			and (
					(isnull(A.Cd_Pes_Agent,'ALL') = 'ALL' and isnull(LLP.Cd_Agente,'') <> 'ALL')
					or 
					(A.Cd_Pes_Agent = LLP.Cd_Agente)
				)

			and (
					(isnull(A.Cd_Armador,'ALLArmador') = 'ALLArmador' and isnull(LLP.Cd_Armador,'') <> 'ALLArmador')
					or 
					(A.Cd_Armador = LLP.Cd_Armador)
				)	

			and (
					(isnull(A.Id_NCM,0) = 0 and isnull(NCM.ID_NCM,1) <> 0)
					or 
					(A.Id_NCM = NCM.ID_NCM)
				)
				
			--and (
			--		(isnull(A.Id_Necessidade_LI,0) = 0 and isnull(CP5.Campo_Dados,'') <> 'A')			
			--		or
			--		(convert(varchar(1),A.Id_Necessidade_LI) = CP5.Campo_Dados)
			--	)

			and (
					(isnull(A.Id_Necessidade_LI,2) = 2 and isnull(CP5.Campo_Dados,'') <> 'A')
					or 
					(convert(varchar(1),A.Id_Necessidade_LI) = CP5.Campo_Dados)
				)

			and (
					(isnull(A.Cd_Tp_Cont,'ALL') = 'ALL' and isnull(CONT.Cd_Tp_Cont,'') <> 'ALL')
					or 
					(A.Cd_Tp_Cont = CONT.Cd_Tp_Cont)
				)
	
			and (
					(isnull(A.Cd_Prod,0) = 0 and isnull(PS.cd_produto,1) <> 0)
					or 
					(A.Cd_Prod = PS.cd_produto)
				)	

				--Leandro

			and (
					(isnull(A.ID_PD,0) = 0 and isnull(CP143.Campo_Dados,'') <> 'A')
					or 
					(A.ID_PD = CP143.Campo_Dados)
				)

			and (
					(isnull(A.Cd_Pes_Operador,'ALL') = 'ALL' and isnull(CP86.Campo_Dados,'') <> 'A')
					or 
					(A.Cd_Pes_Operador = CP86.Campo_Dados)
				)

			and (
					(isnull(A.Id_Hazardous,0) = 0 and isnull(CP185.Campo_Dados,1) <> 0)
					or 
					(A.Id_Hazardous = CP185.Campo_Dados)
				) 


			and (
			/*(isnull(A.cd_tp_pedido,1) = 1 Removido em 13/09/2024 por Leandro Ticket 100-475066 */
					(isnull (A.Cd_Usuario_Cliente,'') <> 'ALL')
					or 
					(A.Cd_Usuario_Cliente = P.PO_Responsible)
				)
			
			--and a.id_alerta in (950, 979, 2256, 2257, 3265, 3266) --Leandro Financeiro 21/05/2025

			and ISNULL(JuntaPDF,'N') = 'S'
			
		Order by TP.Dt_Insert
		--order by TP.Num_Proc
	End




GO
