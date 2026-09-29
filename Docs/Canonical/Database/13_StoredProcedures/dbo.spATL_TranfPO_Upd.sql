SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_TranfPO_Upd](
@Num_ProcTemp varchar(16),
@Num_ProcReal varchar(16)
)
as

Begin Transaction
--Begin Pedido_Ship
update Pedido_ship set Num_Proc = @Num_ProcReal , Dt_ins = GETDATE()
where Num_Proc = @Num_ProcTemp
--End Pedido_Ship

--Begin CUSTOS
update Custo_Cliente set Num_Proc = @Num_ProcReal
where Num_Proc = @Num_ProcTemp

update Custo_Processo set Num_Proc = @Num_ProcReal --, Dt_Rateio = GETDATE()
where Num_Proc = @Num_ProcTemp
--End CUSTOS

--Begin SOLICITACAO LI
update Solicitacao_LI set Num_Proc = @Num_ProcReal --, Obs_LI = Obs_LI + ' Tranferido: '+  @Num_ProcTemp
where Num_Proc = @Num_ProcTemp
--End SOLICITACAO LI

--Begin Historico
update Hist_Geral set HSGProcesso = @Num_ProcReal--, HSDDescricao = HSDDescricao +  ' Tranferido: '+  @Num_ProcTemp
where HSGProcesso = @Num_ProcTemp
--End Historico
--select top 100 * from Hist_Geral
--where HSGProcesso ='IMFMC21501002BR'
--order by HSGData desc
--where HSGProcesso= 'IMLVS21501001BR'

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END
Commit Transaction 




GO
