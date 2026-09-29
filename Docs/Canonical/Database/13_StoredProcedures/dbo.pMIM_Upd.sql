SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pMIM_Upd  
(
@Num_Proc			varchar(14),
@Dt_Emis			varchar(10), 
@Dt_Saida			varchar(10), 
@Dt_Desova			varchar(10),
@Dt_Rcb			varchar(10),
@Dt_Reg_Alf			varchar(10), 
@Reg_Alf			varchar(10), 
@CIMC				varchar(12), 
@MAWB			varchar(25), 
@Sub_Master			varchar(25), 
@Sub_Master_Col		varchar(25), 
@Cd_Consig			varchar(10), 
@Cd_Export			varchar(10), 
@Cd_Org			varchar(3), 
@Cd_Dst			varchar(3), 
@Cd_Armador			varchar(3), 
@Cd_Armador_SM  		varchar(3), 
@Cd_Transb			varchar(3), 
@Navio_Transb			varchar(15), 
@ID_Viagem			Int, 
@IRIN				varchar(8), 
@Cod_Rec			varchar(2), 
@Cd_Terminal			varchar(3), 
@Qtd_Tot_Vol			float, 
@Vol_Tot			float,
@Peso_Bruto			float, 
@Tp_Frete			char(1),
@Cd_Tp_Moeda		varchar(3), 
@Vlr_Frete			float(8), 
@Qtd_HAWB			char(2),
@Ref_Int			varchar(20),
@Nivel_DL			varchar(3), 
@Obs				varchar(2000),
@Navio_MIM			varchar(20)=Null, 
@Viagem_MIM			varchar(10)=Null,
@Dt_Atrac			varchar(10)=Null, 
@Dt_Oper 			varchar(10)=Null,
@Cd_Armazem			varchar(3)=Null,
@Dt_Ent_Term			datetime=Null,
@Dt_Lib_Bl			datetime=Null,
@AWB				varchar(30)=Null,
@Dt_Rec_Doc			datetime=Null,
@Dt_Doc_Camb		datetime=Null,
@DtRedest_MIM		datetime=null
)
 AS
	Begin Transaction 
	If Exists(Select Num_Proc_MIM From Master_Imp_Mar Where Num_Proc_MIM = @Num_Proc)
		Begin 
			Update 
				House_Imp_Mar 
			Set 
				ID_Viagem = @ID_Viagem 
			Where 
				Num_Proc_MIM = @Num_Proc
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return -1
				End
			Update
				Master_Imp_Mar
			Set 
				Num_Proc_MIM = @Num_Proc,
				Dt_Emis_MIM = @Dt_Emis, 
				Dt_Saida_MIM = @Dt_Saida, 
				Dt_Desova_MIM = @Dt_Desova, 
				Dt_Rcb_MIM = @Dt_Rcb,
				Dt_Reg_Alf_MIM = @Dt_Reg_Alf, 
				Reg_Alf_MIM = @Reg_Alf, 
				CIMC_MIM = @CIMC, 
				MAWB_MIM = @MAWB,
				Sub_Master_MIM = @Sub_Master, 
				Sub_Master_Col_MIM = @Sub_Master_Col, 
				Cd_Consig_MIM  = @Cd_Consig, 
				Cd_Export_MIM = @Cd_Export, 
				Cd_Org_MIM = @Cd_Org, 
				Cd_Dst_MIM = @Cd_Dst, 
				Cd_Armador = @Cd_Armador, 
				Cd_Armador_SM   = @Cd_Armador_SM, 
				Cd_Transb_MIM = @Cd_Transb, 
				Navio_Transb_MIM = @Navio_Transb,
				ID_Viagem = @ID_Viagem, 
				IRIN_MIM = @IRIN, 
				Cod_Rec_MIM  = @Cod_Rec, 
				Cd_Armazem = @Cd_Armazem, 
				Cd_Terminal = @Cd_Terminal, 
				Qtd_Tot_Vol_MIM = @Qtd_Tot_Vol, 
				Vol_Tot_MIM = @Vol_Tot, 
				Peso_Bruto_MIM  = @Peso_Bruto, 
				Tp_Frete_MIM  = @Tp_Frete, 
				Cd_Tp_Moeda  = @Cd_Tp_Moeda, 
				Vlr_Frete_MIM = @Vlr_Frete, 
				Qtd_HAWB_MIM     = @Qtd_HAWB, 
				Ref_Int_MIM  = @Ref_Int, 
				Nivel_DL = @Nivel_DL,
				Obs_MIM   = @Obs,
				Navio_MIM = @Navio_MIM, 
				Viagem_MIM = @Viagem_MIM,
				Dt_Atrac_MIM = @Dt_Atrac, 
				Dt_Oper_MIM =@Dt_Oper,
				Dt_Ent_Term=@Dt_Ent_Term, 
				Dt_Lib_Bl=@Dt_Lib_Bl, 
				AWB=@AWB, 
				Dt_Rec_Doc=@Dt_Rec_Doc, 
				Dt_Doc_Camb=@Dt_Doc_Camb,
				DtRedest_MIM = @DtRedest_MIM
			Where
				Num_Proc_MIM = @Num_Proc 
			

			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return - 2
				End 

			Update 
				House_Imp_Mar 
			Set 
				Navio_HIM   = @Navio_MIM,     
				Viagem_HIM = @Viagem_MIM, 
				Id_Viagem = @ID_Viagem, 
				Dt_Cheg_HIM = @Dt_Atrac

			Where
				Left(Num_Proc_HIM, 14) = @Num_Proc

			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return - 3
				End 
			Else
				Begin 
					Commit Transaction 
					Return 1 
				End 
		End 
	Else
		Return - 1
GO
