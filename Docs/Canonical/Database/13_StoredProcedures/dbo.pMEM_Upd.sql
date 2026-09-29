SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE pMEM_Upd
(
@Num_Proc				varchar(14), 
@Dt_Emis				varchar(10)='',
@Dt_Estuf				varchar(10)='', 
@Dt_Saida				varchar(10)='', 
@MAWB				varchar(25)='', 
@Cd_Consig				varchar(10)='', 
@Cd_Export				varchar(10)='', 
@Cd_Notify				varchar(10)='',
@Cd_Org				varchar(3)='',
@Cd_Dst				varchar(3)='',
@Id_Viagem				Int=Null,
@Trf_Net				Float=Null, 
@Qtd_Tot_Vol				Float=Null, 
@Vol_Tot				Float=Null, 
@Peso_Bruto				Float=Null, 
@Tp_Frete				Char(1)='',
@Cd_Tp_Moeda			Varchar(3)='', 
@Vlr_Frete				Float=Null, 
@Qtd_HAWB				Char(2)='', 
@Nivel_DL				Varchar(3)='', 
@Cd_Armador				VarChar(3)='',
@Obs					Varchar(2000)='',
@Cd_Terminal				VarChar(3),
@ETA_MEM				datetime=null,
@ETD_MEM				datetime=null
)
-- Parâmetros de Retorno 
-- (-1) Erro de Chave 
-- (-2) Erro no Processo de Update 
 AS
	If Exists(Select Num_Proc_MEM From Master_Exp_Mar Where Num_Proc_MEM = @Num_Proc)
		Begin 
			Update 
				Master_Exp_Mar
			Set 
				Dt_Emis_MEM = @Dt_Emis,
				Dt_Estuf_MEM = @Dt_Estuf,
				Dt_Saida_MEM = @Dt_Saida,
				MAWB_MEM = @MAWB,
				Cd_Consig_MEM = @Cd_Consig,
				Cd_Export_MEM = @Cd_Export,
				Cd_Notify_MEM = @Cd_Notify,
				Cd_Org_MEM = @Cd_Org, 
				Cd_Dst_MEM = @Cd_Dst, 
				ID_Viagem = @ID_Viagem, 
				Trf_Net_MEM= @Trf_Net, 
				Qtd_Tot_Vol_MEM = @Qtd_Tot_Vol,
				Vol_Tot_MEM = @Vol_Tot, 
				Peso_Bruto_MEM = @Peso_Bruto, 
				Tp_Frete_MEM = @Tp_Frete, 
				Cd_Tp_Moeda = @Cd_Tp_Moeda, 
				Vlr_Frete_MEM = @Vlr_Frete, 
				Qtd_HAWB_MEM = @Qtd_HAWB,
				Nivel_DL = @Nivel_DL,
				Cd_Armador = @Cd_Armador, 
				Obs_MEM = @Obs,
				Cd_Terminal = @Cd_Terminal,
				ETA_MEM = @ETA_MEM, 
				ETD_MEM = @ETD_MEM	
			Where
				Num_Proc_Mem = @Num_Proc

			If @@RowCount <> 1 
				Return - 2 
			Else
				Return 1 
		End 
	Else 
		Return -1

GO
