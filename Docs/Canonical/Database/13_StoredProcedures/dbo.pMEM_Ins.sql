SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE  PROCEDURE pMEM_Ins 
(
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
@Cd_Terminal				VarChar(3)='',
@Num_Proc				varchar(14) ='' OUTPUT ,
@ETA_MEM				datetime=null,
@ETD_MEM				datetime=null
)
 AS
	-- Parâmetros de Retorno 
	-- (-2)  Erro no processo de Inserção 
			
		Begin Transaction
 		Execute pMEMReferencia_Ins @Cd_Org, 'EM', @Referencia = @Num_Proc OUTPUT
		Insert Into 
			Master_Exp_Mar
			(Num_Proc_MEM,Dt_Emis_MEM,Dt_Estuf_MEM,Dt_Saida_MEM,MAWB_MEM,Cd_Consig_MEM,Cd_Export_MEM,Cd_Notify_MEM,Cd_Org_MEM, 
			Cd_Dst_MEM, Id_Viagem, Trf_Net_MEM, Qtd_Tot_Vol_MEM, Vol_Tot_MEM, Peso_Bruto_MEM, Tp_Frete_MEM, Cd_Tp_Moeda, Vlr_Frete_MEM, Qtd_HAWB_MEM,
			Nivel_DL, Cd_Armador, Obs_MEM, Cd_Terminal, ETA_MEM, ETD_MEM)
		Values 
			(@Num_Proc, @Dt_Emis, @Dt_Estuf, @Dt_Saida, @MAWB, @Cd_Consig, @Cd_Export, @Cd_Notify, @Cd_Org, @Cd_Dst, @Id_Viagem, @Trf_Net, @Qtd_Tot_Vol,
			@Vol_Tot,@Peso_Bruto, @Tp_Frete, @Cd_Tp_Moeda, @Vlr_Frete, @Qtd_HAWB,@Nivel_DL, @Cd_Armador, @Obs, @Cd_Terminal, @ETA_MEM, @ETD_MEM)
		If @@RowCount <> 1 
			Begin 
				RollBack Transaction
				Return - 2
			End 
		Else
			Begin 
				Commit Transaction 
				Return 1 
			End

GO
