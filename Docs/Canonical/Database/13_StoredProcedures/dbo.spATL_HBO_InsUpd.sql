SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help LLP_BDP_OUT
CREATE PROCEDURE [dbo].[spATL_HBO_InsUpd]
(
	@Processo			VarChar(16),
	@Dt_Emis			varchar(10),
	@Descr_Serv_HBO		Varchar(2000),
	@cd_cliente_hbo		Varchar(10),	
	@Cd_Tp_Oper			Varchar(3),
--Variaveis LLP_BDP_OUT
	@Id_TP_Servico		int	,	
	@Cd_Usuario			Varchar(10),
	@Id_status			int,
	@ID_PD				int,
	@ProcessoN		VarChar(16) OUTPUT
	
)

 AS

Begin Transaction

	Declare @Seq			Varchar(10)

	if @Processo is null
		Begin 
			Declare @Grupo	varchar(3)			
			Set @Grupo = (select top 1 Grupo from Pessoa_LLP PL with(nolock) Join Grupo G with(nolock) on G.Cd_Pes_Grupo = PL.Cd_Pes_Grupo where Cd_Pes = @cd_cliente_hbo)
			Set @Processo = 'BO' + @Grupo +cast(year(getdate()) as Varchar)
			Set @Processo=@Processo+Right( '000' + cast(month(getdate()) as VarChar),2)
			Set @Seq=(Select iSNULL(max(right(left(Num_Proc_LBO,14),3)),0)+1 from LLP_BDP_OUT where left(Num_Proc_LBO,11)=@Processo)			
			Set @Seq='000'+@Seq			
			Set @Seq=right(@Seq,3)			
			Set @Processo=@Processo+@Seq+(select top 1 cd_versao from versao)
						
			Insert Into	House_BDP_OUT
					(Num_Proc_HBO,Dt_Emis_HBO,Descr_Serv_HBO,cd_cliente_hbo,Cd_Tp_Oper)
				Values
					(@Processo,@Dt_Emis,@Descr_Serv_HBO,@cd_cliente_hbo,@Cd_Tp_Oper)
			Set @ProcessoN = @Processo
		End
	Else
		Begin
			Update
				House_BDP_OUT
			Set
				Dt_Emis_HBO	= @Dt_Emis,
				Descr_Serv_HBO	= @Descr_Serv_HBO,
				cd_cliente_hbo = @cd_cliente_hbo,
				Cd_Tp_Oper  = @Cd_Tp_Oper
			Where
				Num_Proc_HBO	= @Processo
	End

--TRATAMENTO PARA A TABELA LLP_IMP_OUTROS
	If  exists (select Num_Proc_LBO from LLP_BDP_OUT where Num_Proc_LBO=@Processo)
		Begin
			Update
				LLP_BDP_OUT
			Set
				Cd_Usuario			= isnull(@Cd_Usuario,cd_usuario),
				id_tp_servico		= @id_tp_servico,				
				id_status			= @Id_status
			Where
				Num_Proc_LBO	= @Processo
		end
	Else
		Begin
			Insert Into
				LLP_BDP_OUT
				(Num_Proc_LBO,Cd_Usuario,id_tp_servico,id_status)
			Values
				(@Processo,@Cd_usuario,@id_tp_servico,@Id_status)
		end
		
	if @ID_PD is not null
		BEGIN	
			--Inserir no Additional Fields
			If  exists (select Campo_Dados from Campo_Processo with(nolock) where Id_Campo = 143 
				and Num_Proc = @Processo)
				Begin
					Update
						Campo_Processo
					Set
						Campo_Dados = @ID_PD
					Where
						Id_Campo = 143 and Num_Proc = @Processo
				end
			Else
				Begin
					Insert Into
						Campo_Processo
						(Num_Proc,Id_Campo,Campo_Dados,Dt_Ins,cd_usuario)
					Values
						(@Processo,143,@ID_PD,GETDATE(),@Cd_Usuario)
				end
		END

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction



GO
